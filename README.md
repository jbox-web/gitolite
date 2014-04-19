## ![logo](https://raw.github.com/jbox-web/gitolite/gh-pages/images/git_logo.png) gitolite

### A gem which makes configuring your own Git hosting easy ;)

This gem is designed to provide a Ruby interface to the [Gitolite](https://github.com/sitaramc/gitolite) Git backend system.

It provides these functionalities :

* [SSH Public Keys Management](https://github.com/jbox-web/gitolite/wiki/Features#wiki-ssh-public-keys-management)
* [Repositories Management](https://github.com/jbox-web/gitolite/wiki/Features#wiki-repositories-management)
* [Gitolite Admin Repository Bootstrapping](https://github.com/jbox-web/gitolite/wiki/Features#wiki-gitolite-admin-repository-bootstrapping)

You can follow announcements [here](https://github.com/jbox-web/gitolite/wiki/Announcements) or take a look at the [roadmap](https://github.com/jbox-web/gitolite/wiki/Roadmap).

## Code status

* [![Build Status](https://travis-ci.org/jbox-web/gitolite.png)](https://travis-ci.org/jbox-web/gitolite)

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

## Copyrights & License
gitolite is completely free and open source and released under the [MIT License](https://github.com/jbox-web/gitolite/blob/devel/LICENSE.txt).

Copyright (c) 2013-2014 Nicolas Rodriguez (nrodriguez@jbox-web.com), JBox Web (http://www.jbox-web.com)

Copyright (c) 2011-2013 Stafford Brunk (stafford.brunk@gmail.com)

## Contribute

You can contribute to this plugin in many ways such as :
* Helping with documentation
* Contributing code (features or bugfixes)
* Reporting a bug
* Submitting translations

You can also donate :)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FBT7E7DAVVEEU)