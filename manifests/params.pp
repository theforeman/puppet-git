class git::params {
  $bin = '/usr/bin/git'
  $pkg = $::operatingsystem ? {
    /(Debian|Ubuntu)/ => ['git-core'],
    default           => ['git'],
  }
}
