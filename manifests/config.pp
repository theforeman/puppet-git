# == Define: git::config
#
# === Parameters
#
# [*ensure*]
#   Valid values: 'present', 'absent'
#
# [*key*]
#   The git-config key to set. Example: +http.sslCAPath+.
#   *namevar* - defaults to +$title+ if not set.
#
# [*value*]
#   The value to set for this key. Optional.
#   If +ensure=absent+, passing a value makes the key removal match that value
#   exactly. If there is no value, the match is only by key. Just as
#   git-config works natively.
# 
# [*scope*]
#   In what _scope_ to do the config. Default: +system+. Valid values:
#   +system+, +global+, +repo+ or +file+.
#   For _repo_ scope you have to pass the path to a repository as the +repo+
#   parameter. For _file_ scope you have to pass the path to a config file as
#   the +file+ parameter.
#   
# [*repo*]
#   Path to the repository you want to configure. This is passed to 
#   +git config --git-dir+. *Required* when +scope=repo+.
#
# [*file*]
#   Explicitly choose a file for configuration. *Required* when +scope=repo+.
#   
# [*user*]
#   User to run as. Default: +root+.
#
# === Examples
#
# Configure the system-wide git config to use an sslCApath:
#
#   include git
#
#   git::config{"http.sslCApath":
#     value => '/etc/pki/tls/certs',
#   }
#
# === Authors
# 
# Mikael Fridh <frimik@gmail.com>
#
define git::config(
  $ensure = present,
  $key = $title,
  $value = undef,
  $scope = "system",
  $repo = undef,
  $file = undef,
  $user = 'root'
) {
  $git = $::git::params::bin

  case $scope {
    'system','global': {
      $git_scope = "--${scope}"
    }
    'repo': {
      if !$repo {
        fail("Scope: 'repo' requires passing the path to a git repository")
      }
      $git_scope = "--git-dir $repo"
    }
    'file': {
      if !$file {
        fail("Scope: 'file' requires passing the path to a git config file")
      }
      $git_scope = "--file $file"
    }
    default: { fail("Scope is unknown. Not one of ['system', 'global', 'repo', 'file']") }
  }

  $description = "$title in $git_scope"

  # Allow both specific and non-specific keys to be removed
  if $value {
    $setting = "'$key' '$value'"
    $match = "'$key' '^${value}\$'"
  } else {
    $match = "'$key'"
  }

  Exec { user => $user }

  case $ensure {
    'present': {
      exec { "git::config set $description":
        command => "$git config $git_scope $setting",
        unless => "$git config $git_scope --get $match",
        logoutput => on_failure,
      }
    }
    'absent': {
      exec { "git::config unset $description":
        command => "$git config $git_scope --unset $match",
        onlyif => "$git config $git_scope --get $match",
        logoutput => on_failure,
      }
    }
    default: { fail("Parameter 'ensure' not one of ['present', 'absent']") }
  }

}
