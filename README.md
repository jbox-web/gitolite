# gitolite [![Build Status](https://travis-ci.org/jbox-web/gitolite.png)](https://travis-ci.org/jbox-web/gitolite)

This gem is designed to provide a Ruby interface to the [gitolite](https://github.com/sitaramc/gitolite) git backend system.  I am aiming to provide all management functionality that is available via the gitolite-admin repository (like SSH keys, repository permissions, etc)

This gem can still have problems.  Please file an issue if you encounter a bug.  If you have a feature request, file one please.

## Features ##
* Allows for the creation and management of repos within gitolite
* Allows for the creation and deletion of SSH keys within gitolite
* Allows for the bootstrapping of a gitolite-admin repository

## Requirements ##
* Ruby 1.9.x or 2.0.x
* a working [gitolite](https://github.com/sitaramc/gitolite) installation
* the <tt>gitolite-admin</tt> repository checked out locally

## Installation ##

    gem install jbox-gitolite


## Thread Safety ##
Now the gem should be thread safe as all ```chdir``` has been removed.
There's no global variables and only well used constants.

## Caveats ##
### Windows compatibility ###
The grit gem (which is used for under-the-hood git operations) does not currently support Windows.  Until it does, gitolite will be unable to support Windows.

### Group Ordering ###
When the gitolite backend parses the config file, it does so in one pass.  Because of this, groups that are modified after being used do not see those changes reflected in previous uses.

For example:

    @groupa = bob joe sue
    @groupb = jim @groupa
    @groupa = sam

Group b will contain the users <tt>jim, bob, joe, and sue</tt>

The gitolite gem, on the other hand, will <em>always</em> output groups so that all modifications are represented before it is ever used.  For the above example, group b will be output with the following users: <tt>jim, bob, joe, sue, and sam</tt>.  The groups in the config file will look like this:

    @groupa = bob joe sue sam
    @groupb = jim @groupa

# Contributing #
* Tests!  If you ask me to pull changes that are not adequately tested,  I'm not going to do it.
* If you introduce new features/public methods on objects, you must update the README.

### Contributors ###
* Alexander Simonov - [simonoff](https://github.com/simonoff)
* Pierre Guinoiseau - [peikk0](https://github.com/peikk0)
* Nicolas Rodriguez - [n-rodriguez](https://github.com/n-rodriguez)

## Documentation ##
* Rdoc is coming eventually

## Future ##
* support folders in the keydir
* support include tags
* cleanup methods to make adding and removing easier (like add_key should accept an array of keys)
