define git::repo (
  $target,
  $bare    = false,
  $source  = false,
  $user    = 'root'
) {

  require git::params

  if $source {
    $cmd = "${git::params::bin} clone ${source} ${target} --recursive"
  } else {
    if $bare {
      $cmd = "${git::params::bin} init --bare ${target}"
    } else {
      $cmd = "${git::params::bin} init ${target}"
    }
  }

  $creates = $bare ? {
    true  => "${target}/objects",
    false => $target,
  }

  exec { "git_repo_for_${name}":
    command => $cmd,
    creates => $creates,
    require => Class['git::install'],
    user    => $user
  }
}
