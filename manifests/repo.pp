# = Definition: git::repo
#
# == Parameters:
#
# $target::   Target folder. Required.
#
# $bare::     Create a bare repository. Defaults to false.
#
# $source::   Source to clone from. If not specified, no remote will be used.
#
# $user::     Owner of the repository. Defaults to root.
#
# $group::    Group of the repository. Defaults to root.
#
# $mode::     Mode of the repository root. Defaults to 0755.
#
# $bin::      Git binary. Defaults to /usr/bin/git or /usr/local/bin/git. 
#
# == Usage:
#
#   git::repo {'mygit':
#     target => '/home/user/puppet-git',
#     source => 'git://github.com/theforeman/puppet-git.git',
#     user   => 'user',
#   }
#
define git::repo (
  $target,
  $bare    = false,
  $source  = false,
  $user    = 'root',
  $group   = 'root',
  $mode    = '0755',
  $workdir = '/tmp',
  $args    = undef,
  $bin     = $git::params::bin,
) {

  if $args {
    validate_string($args)
  }

  $args_real = $bare ? {
    true    => "${args} --bare",
    false   => $args,
  }

  if $source {
    $cmd = "${bin} clone ${args_real} --recursive ${source} ${target}"
  } else {
    $cmd = "${bin} init ${args_real} ${target}"
  }

  $creates = $bare ? {
    true  => "${target}/objects",
    false => "${target}/.git",
  }

  file { $target:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }
  ->
  exec { "git_repo_for_${name}":
    command => $cmd,
    creates => $creates,
    cwd     => $workdir,
    require => Class['git::install'],
    user    => $user,
  }
}
