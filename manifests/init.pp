# =Class: git
#
# Sets up requirements for git. See git::repo for more information on how to
# use this module.
#
class git (
  $package        = $::git::params::package,
  $package_ensure = $::git::params::package_ensure,

  ### START Hiera Lookups ###
  $repo = hiera_has('git::repo', {}),
  ### END Hiera Lookups ###
) inherits ::git::params {
  include ::git::install
  
  create_resources('git::repo', $repo)
}
