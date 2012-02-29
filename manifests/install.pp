class git::install {
  package {$git::params::pkg: ensure => installed }
}
