# =Class: git
#
# Sets up requirements for git. See git::repo for more information on how to
# use this module.
#
class git ($package_ensure = $git::params::package_ensure, $package = $git::params::package,) inherits git::params {
  include git::install
}
