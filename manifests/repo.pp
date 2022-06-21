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
# @param timeout
#   Optional Timeout in Seconds for the Git-Command to execute.
#   Puppet's "exec" defaults to 300 Seconds
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
  String[1] $target,
  Boolean $bare = false,
  Optional[Variant[String[1], Sensitive[String[1]]]] $source = undef,
  String[1] $user = 'root',
  String[1] $group = 'root',
  Stdlib::Filemode $mode = '0755',
  Stdlib::Absolutepath $workdir = '/tmp',
  Optional[String] $args = undef,
  Optional[Integer] $timeout = undef,
  String[1] $bin = $git::bin,
) {
  require git

  $args_real = $bare ? {
    true    => "${args} --bare",
    false   => $args,
  }

  if $source =~ Sensitive {
    $cmd = Sensitive.new("${bin} clone ${args_real} --recursive ${source.unwrap} ${target}")
  } elsif $source {
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
    timeout => $timeout,
    user    => $user,
  }
}
