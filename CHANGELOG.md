# Changelog

## [4.0.0](https://github.com/theforeman/puppet-git/tree/4.0.0) (2018-01-25)
[Full Changelog](https://github.com/theforeman/puppet-git/compare/3.0.0...4.0.0)

**Breaking changes:**

- Update hiera yaml to version 5 [\#30](https://github.com/theforeman/puppet-git/pull/30) ([mmoll](https://github.com/mmoll))

**Implemented enhancements:**

- remove EOL OSes, add new ones [\#33](https://github.com/theforeman/puppet-git/pull/33) ([mmoll](https://github.com/mmoll))
- Use stdlib for ensure\_packages and Absolutepath [\#32](https://github.com/theforeman/puppet-git/pull/32) ([ekohl](https://github.com/ekohl))

## 3.0.0
* Drop Puppet 3 support
* Use Puppet 4 data types
* Use Hiera data provider
* Support Debian 9
* Allow overriding the git binary from the main class

## 2.0.0
* Drop Ruby 1.8.7 support

## 1.6.0
* Add group, mode parameters for repo directory permissions
* Add args parameter for arbitrary git arguments
* Ensure repo directory is present before running git
* Support bare cloning with git::repo::bare set
* Support Puppet 3.0 minimum
* Support Fedora 21, remove Debian 6 (Squeeze), add Debian 8 and Ubuntu 16.04

## 1.5.0
* Add FreeBSD support
* Support Puppet 4 and future parser

## 1.4.1
* Add minimal tests, increased linting
* Fixes to metadata quality

## 1.4.0
* Parameterize 'git' class, add package_ensure parameter

## 1.3.2
* Run git from a temporary working directory to avoid cwd errors

## 1.3.1
* Always default to 'git' package, fix related bugs
