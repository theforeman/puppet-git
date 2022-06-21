# Sets up requirements for git
#
# @see git::repo on how to use this module.
#
# @param bin The path to the git binary
#
# @param package Override the name of the git package(s) to include.
#
# @param package_ensure Override the git package ensure
#
# @example Override the git version
#   class { 'git':
#     package_ensure => '2.1.0',
#   }
#
class git (
  Optional[String[1]] $bin = undef,
  Optional[String[1]] $package = undef,
  Optional[String[1]] $package_ensure = undef,
) {
  ensure_packages([$package], { 'ensure' => $package_ensure })
}
