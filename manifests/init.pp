# =Class: git
#
# Sets up requirements for git. See git::repo for more information on how to
# use this module.
#
# == Parameters:
#
# $bin:: The path to the git binary
#
# $package::  Override the name of the git package(s) to include.
#
# $package_ensure:: Override the git package ensure
#
# == Usage:
#
# Example: Override the git version
#
#   class { 'git':
#     package_ensure => '2.1.0',
#   }
#
class git (
  $bin = undef,
  $package = undef,
  $package_ensure = undef,
) {
  package { $package:
    ensure => $package_ensure,
  }
}
