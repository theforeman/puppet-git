class git::install {
  require git::params

  package {$git::params::pkg: ensure => installed }
}
