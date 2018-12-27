# Check out a git repository
#
# @param target
#   Target folder
#
# @param bare
#   Create a bare repository
#
# @param source
#   Source to clone from. If not specified, no remote will be used.
#
# @param user
#   Owner of the repository
#
# @param group
#   Group of the repository
#
# @param mode
#   Mode of the repository root
#
# @param workdir
#   The working directory while executing git
#
# @param args
#   Optional arguments to the git command
#
# @param bin
#   Git binary
#
# @example Clone a git repository
#   git::repo {'mygit':
#     target => '/home/user/puppet-git',
#     source => 'https://github.com/theforeman/puppet-git.git',
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
