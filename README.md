## ![logo](https://raw.github.com/jbox-web/gitolite/gh-pages/images/git_logo.png) gitolite

[![GitHub license](https://img.shields.io/github/license/jbox-web/gitolite.svg)](https://github.com/jbox-web/gitolite/blob/devel/LICENSE)
[![Gem](https://img.shields.io/gem/v/jbox-gitolite.svg)](https://rubygems.org/gems/jbox-gitolite)
[![Gem](https://img.shields.io/gem/dv/jbox-gitolite/1.2.6.svg)](https://rubygems.org/gems/jbox-gitolite/versions/1.2.6)
[![Build Status](https://travis-ci.org/jbox-web/gitolite.svg?branch=devel)](https://travis-ci.org/jbox-web/gitolite)
[![Code Climate](https://codeclimate.com/github/jbox-web/gitolite.png)](https://codeclimate.com/github/jbox-web/gitolite)
[![Dependency Status](https://gemnasium.com/jbox-web/gitolite.svg)](https://gemnasium.com/jbox-web/gitolite)
[![Coverage Status](https://coveralls.io/repos/jbox-web/gitolite/badge.png?branch=devel)](https://coveralls.io/r/jbox-web/gitolite?branch=devel)
[![Test Coverage](https://codeclimate.com/github/jbox-web/gitolite/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/gitolite)

### A gem which makes configuring your own Git hosting easy ;)

This gem is designed to provide a Ruby interface to the [Gitolite](https://github.com/sitaramc/gitolite) Git backend system.

It is based on [gitlab-grit](https://github.com/gitlabhq/grit) to manage the repository.

It provides these functionalities :

* [SSH Public Keys Management](https://github.com/jbox-web/gitolite/wiki/Features#wiki-ssh-public-keys-management)
* [Repositories Management](https://github.com/jbox-web/gitolite/wiki/Features#wiki-repositories-management)
* [Gitolite Admin Repository Bootstrapping](https://github.com/jbox-web/gitolite/wiki/Features#wiki-gitolite-admin-repository-bootstrapping)

You can follow announcements [here](https://github.com/jbox-web/gitolite/wiki/Announcements) or take a look at the [roadmap](https://github.com/jbox-web/gitolite/wiki/Roadmap).

You'll find a new implementation of this library here : https://github.com/oliverguenther/gitolite-rugged.

The new one is based on https://github.com/libgit2/rugged and provide the same functionalities.

## Requirements ##

* Ruby 1.9.x or 2.0.x
* a working [gitolite](https://github.com/sitaramc/gitolite) installation
* the <tt>gitolite-admin</tt> repository checked out locally

## Installation ##

```ruby
gem 'jbox-gitolite', '~> 1.2.6'
```

then `bundle install`.

Read the documentation and more in the [Wiki](https://github.com/jbox-web/gitolite/wiki).

## Contribute

You can contribute to this plugin in many ways such as :
* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations
