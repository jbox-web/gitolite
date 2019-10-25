## ![logo](https://raw.github.com/jbox-web/gitolite/gh-pages/images/git_logo.png) gitolite

[![GitHub license](https://img.shields.io/github/license/jbox-web/gitolite.svg)](https://github.com/jbox-web/gitolite/blob/devel/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/gitolite.svg)](https://github.com/jbox-web/gitolite/releases/latest)
[![Gem](https://img.shields.io/gem/v/jbox-gitolite.svg)](https://rubygems.org/gems/jbox-gitolite)
[![Gem](https://img.shields.io/gem/dtv/jbox-gitolite.svg)](https://rubygems.org/gems/jbox-gitolite)
[![Build Status](https://travis-ci.org/jbox-web/gitolite.svg?branch=devel)](https://travis-ci.org/jbox-web/gitolite)
[![Code Climate](https://codeclimate.com/github/jbox-web/gitolite.png)](https://codeclimate.com/github/jbox-web/gitolite)
[![Test Coverage](https://codeclimate.com/github/jbox-web/gitolite/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/gitolite)

### A Ruby interface to manage the Gitolite Git backend system, easy ;)

This gem is designed to provide a Ruby interface to the [Gitolite](https://github.com/sitaramc/gitolite) Git backend system via [gitlab-grit](https://github.com/gitlabhq/grit) gem.

It provides these functionalities :

* SSH Public Keys Management
* Repositories Management
* Gitolite Admin Repository Bootstrapping

***Please note : this project is not maintained anymore.***

***You'll find a new implementation of this library here : [gitolite-rugged](https://github.com/jbox-web/gitolite-rugged).***

## Requirements ##

* Ruby 1.9.x or 2.0.x
* a working [Gitolite](https://github.com/sitaramc/gitolite) installation

## Installation ##

```ruby
gem 'jbox-gitolite', '~> 1.2.6'
```

then `bundle install`.

## Usage

### Load a gitolite-admin repo

```ruby
require 'gitolite'
ga_repo = Gitolite::GitoliteAdmin.new("/path/to/gitolite/admin/repo")

# or with options :
ga_repo = Gitolite::GitoliteAdmin.new("/path/to/gitolite/admin/repo", :config_file => 'example.conf',
                                                                      :debug       => true,
                                                                      :timeout     => 20,
                                                                      :env         => {'GIT_SSH' => '/path/to/script/file'})
```

This method can only be called on an existing gitolite-admin repo. If you need to create a new gitolite-admin repo, see "Bootstrapping".

### Configuration Files

```ruby
conf = ga_repo.config

# Empty configs can also be initialized
conf2 = Config.init # => defaults to a filename of gitolite.conf
conf2 = Config.init("new_config.conf")

# Filename is set to whatever the filename was when the config was created
conf.filename # => "gitolite.conf"
conf2.filename # => "new_config.conf"

# Filename can be changed via the setter
conf2.filename = "new_config.conf"

# *to_file* will write the config out to the file system using the value of the filename attribute.
# An alternative filename can also be specified
conf.to_file("/new/config/path") # => writes /new/config/path/gitolite.conf
conf.to_file("/new/config/path", "test.conf") # => writes /new/config/path/test.conf
```

### Repo management

```ruby
repo = Gitolite::Config::Repo.new("AwesomeRepo")

# For a list of permissions, see http://sitaramc.github.com/gitolite/conf.html#gitolite
repo.add_permission("RW+", "", "bob", "joe", "susan")

# Set a git config option to the repo
repo.set_git_config("hooks.mailinglist", "gitolite-commits@example.tld") # => "gitolite-commits@example.tld"

# Unset a git config option from the repo
repo.unset_git_config("hooks.mailinglist") # => "gitolite-commits@example.tld"

# Set a gitolite option to the repo
repo.set_gitolite_option("mirroring.master", "kenobi") # => "kenobi"

# Remove a gitolite option from the repo
repo.unset_gitolite_option("mirroring.master") # => "kenobi"

# Add repo to config
conf.add_repo(repo)

# Delete repo by object
conf.rm_repo(repo)

# Delete a repo by name
conf.rm_repo("AwesomeRepo")
conf.rm_repo(:AwesomeRepo)

# Test if repo exists by name
conf.has_repo?('cool_repo') # => false
conf.has_repo?(:cool_repo) # => false

# Can also pass a Gitolite::Config::Repo object
repo = Gitolite::Config::Repo.new('cool_repo')
conf.has_repo?(repo) # => true

# Get a repo object from the config
repo = conf.get_repo('cool_repo')
repo = conf.get_repo(:cool_repo)
```

### SSH Key Management

```ruby
# Three ways to create keys : manually, from an existing key, or from a string representing a key
key = Gitolite::SSHKey.new("ssh-rsa", "big-public-key-blob", "email")
key2 = Gitolite::SSHKey.from_file("/path/to/ssh/key.pub")

key_string = File.read("/path/to/ssh/key.pub")
key3 = Gitolite::SSHKey.from_string(key_string, "owner")

# Create key with a name #
key = Gitolite::SSHKey.new("ssh-rsa", "big-public-key-blob", "email", "keyname")
key2 = Gitolite::SSHKey.from_file("/path/to/ssh/key.pub")

key_string = File.read("/path/to/ssh/key.pub")
key3 = Gitolite::SSHKey.from_string(key_string, "owner", "keyname")

# Add the keys
ga_repo.add_key(key)
ga_repo.add_key(key2)
ga_repo.add_key(key3)

# Remove key2
ga_repo.rm_key(key2)
```

### Save changes ###

```ruby
ga_repo.save(commit_message, :author => 'John Doe <john.doe@example.com>')
```

When this method is called, all changes get written to the file system and commited in git. For the time being, gitolite assumes full control of the gitolite-admin repository.
This means that any keys in the keydir that are not being tracked will be removed and any human changes to gitolite.conf will be erased.
The commit message is optional. A generic message is set if missing. Optionally you can pass the author as above.

### Apply changes ###

```ruby
ga_repo.apply
```

This method will push all changes to <tt>origin master</tt>.

### Save and apply ###

```ruby
ga_repo.save_and_apply(commit_message)
```

This method will add files, commit and push all changes to <tt>origin master</tt> in the same transaction.
The commit message is optional. A generic message is set if missing.

### Updating remote changes ###

```ruby
# In order to avoid conflicts, this will perform a reset! by default
# pass :reset => false to disable the reset (Git conflicts will have to be manually fixed)
ga_repo.update
ga_repo.update(:reset => false)

# Update while performing a rebase
ga_repo.update(:rebase => true)
```

### Reloading from the file system ###

```ruby
ga_repo.reload!
```

### Resetting to HEAD, destroying all local changes (including untracked files) ###

```ruby
# This will also perform a reload!
ga_repo.reset!
```

### Bootstrapping ###

```ruby
ga_repo = GitoliteAdmin.bootstrap("/path/to/new/gitolite/repo")
```

This will create the folders <tt>conf</tt> and <tt>keydir</tt> in the supplied path. A config file will also be created in the conf directory.
The default configuration supplies RW+ permissions to a user named git for a repo named <tt>gitolite-admin</tt>. You can specify an options hash to change some values :

```ruby
ga_repo = GitoliteAdmin.bootstrap("/path/to/new/gitolite/repo", {:user => "admin", :perm => "RW"})
```

You can also pass a message to be used for the initial bootstrap commit :

```ruby
ga_repo = GitoliteAdmin.bootstrap("/path/to/new/gitolite/repo", {:message => "Bootstrapped new repo"})
```

Please note that while bootstrapping is supported, I highly recommend that the initial gitolite-admin repo be created by gitolite itself.

## Caveats ##

### Windows compatibility ###

The grit gem (which is used for under-the-hood git operations) does not currently support Windows.  Until it does, gitolite will be unable to support Windows.

### Group Ordering ###

When the gitolite backend parses the config file, it does so in one pass. Because of this, groups that are modified after being used do not see those changes reflected in previous uses.

For example:

```sh
@groupa = bob joe sue
@groupb = jim @groupa
@groupa = sam
```

Group ```b``` will contain the users <tt>jim, bob, joe, and sue</tt>

## Contribute

You can contribute to this plugin in many ways such as :
* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations
