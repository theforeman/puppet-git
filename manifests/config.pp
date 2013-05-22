define git::config(
  $ensure = present,
  $key = $name,
  $value = undef,
  $scope = "system",
  $repo = undef,
  $configfile = undef,
  $user = 'root'
) {
  $git = $::git::params::bin

  case $scope {
    'system','global': {
      $git_scope = "--${scope}"
    }
    'repo': {
      $git_scope = "--file $repo/config"
    }
    'file': {
      $git_scope = "--file $configfile"
    }
    default: { fail("Scope is unknown. Not one of ['system', 'global', 'repo']") }
  }

  $description = "$name in $git_scope"

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
  }

}
