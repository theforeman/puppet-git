class git::params (
  $bin = '/usr/bin/git',
  $package = undef
) {

  $pkg = $package ? {
    undef   => $::operatingystem ? {
      /(?i:Debian|Ubuntu)/ => ['git-core'],
      default              => ['git'],
    },
    default => $package,
  }

}
