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
# $workdir::  The working directory while executing git
#
# $args::     Optional arguments to the git command
#
# $bin::      Git binary
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
  String $target,
  Boolean $bare = false,
  Optional[String] $source = undef,
  String $user = 'root',
  String $group = 'root',
  String $mode = '0755',
  Stdlib::Absolutepath $workdir = '/tmp',
  Optional[String] $args = undef,
  String $bin = $git::bin,
) {
  require git

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
  -> exec { "git_repo_for_${name}":
    command => $cmd,
    creates => $creates,
    cwd     => $workdir,
    user    => $user,
  }
}
