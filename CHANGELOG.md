#### [Release 1.2.7](https://github.com/jbox-web/gitolite/releases/tag/v1.2.7)
***
**Date :** October 25, 2019

**Changelog :**

* Bump gitlab-grit to version [2.7.2](https://github.com/gitlabhq/grit/blob/master/History.txt)

#### [Release 1.2.6](https://github.com/jbox-web/gitolite/releases/tag/v1.2.6)
***
**Date :** September 10, 2014

**Changelog :**

* Bump gitlab-grit to version [2.7.1](https://github.com/gitlabhq/grit/blob/master/History.txt)

#### [Release 1.2.5](https://github.com/jbox-web/gitolite/releases/tag/v1.2.5)
***
**Date :** July 22, 2014

**Changelog :**

* Grit mangle the options hash, clone it.

#### [Release 1.2.4](https://github.com/jbox-web/gitolite/releases/tag/v1.2.4)
***
**Date :** July 22, 2014

**Changelog :**

* Raises ```Grit::Git::CommandFailed``` when the ```:raise``` option is set true and the ```git``` command exits with a non-zero exit status.

#### [Release 1.2.3](https://github.com/jbox-web/gitolite/releases/tag/v1.2.3)
***
**Date :** July 16, 2014

**Changelog :**

* Bump to version 2.7.0 of [gitlab-grit](https://github.com/gitlabhq/grit)

#### [Release 1.2.2](https://github.com/jbox-web/gitolite/releases/tag/v1.2.2)
***
**Date :** April 29, 2014

**Changelog :**

* Rollback to GRATR (Plexus crash in Rails environment, don't know why...)
* Add commit tests for GitoliteAdmin

#### [Release 1.2.1](https://github.com/jbox-web/gitolite/releases/tag/v1.2.1)
***
**Date :** April 22, 2014

**Changelog :**

* Allow key names with '+' character in them
* Replace GRATR by Plexus
* Test if file generation works
* Add tests for GitoliteAdmin
* Bump to last version of development gems

#### [Release 1.2.0](https://github.com/jbox-web/gitolite/releases/tag/v1.2.0)
***
**Date :** April 19, 2014

**Changelog :**

Actually there's not much changes but the last modifications (thread safety, options added) justify this major update.

By the way the wiki has been updated and the test infrastructure too.

#### [Release 1.1.11](https://github.com/jbox-web/gitolite/releases/tag/v1.1.11)
***
**Date :** April 14, 2014

**Changelog :**

* Fix thread safety
* Pass env options as hash to Grit (such as GIT_SSH)
* Pass options hash to save method
* Add Grit.debug option
* Add Grit::Git.git_timeout option
