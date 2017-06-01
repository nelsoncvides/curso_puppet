class nginx (
  String $package   = $nginx::params::package,
  String $owner     = $nginx::params::owner,
  String $group     = $nginx::params::group,
  String $docroot   = $nginx::params::docroot,
  String $confdir   = $nginx::params::confdir,
  String $blockdir  = $nginx::params::blockdir,
  String $logdir    = $nginx::params::logdir,
  String $root      = $nginx::params::root,
  Boolean $highperf = $nginx::params::highperf,
  ) inherits nginx::params {

$user = $facts['os']['family'] ? {
  'redhat'  => 'nginx',
  'debian'  => 'www-data',
  'windows' => 'nobody',
}

File {
  owner => $owner,
  group => $group,
  mode  => '0664',
}

package { 'nginx' :
  ensure => present,
}

nginx::vhost { 'default' :
  docroot => $docroot,
  servername => $facts['fqdn']
}

file { "${docroot}/vhosts" :
  ensure => directory,
}

#file { "${docroot}/index.html" :
#  ensure => file,
#  content => epp('nginx/index.html.epp')
#}

file { "${confdir}/nginx.conf" :
  ensure    => file,
  content   => epp('nginx/nginx.conf.epp',
                    {
                      user     => $user,
                      logdir   => $logdir,
                      confdir  => $confdir,
                      blockdir => $blockdir,
                      highperf => $highperf,
                    }),
  require   => Package[$package],
  notify    => Service['nginx'],
}

#file { "${blockdir}/default.conf" :
#  ensure  => file,
#  content =>  epp('nginx/default.conf.epp',
#                    {
#                      docroot => $docroot,
#                    }),
#  require => Package[$package],
#  notify  => Service['nginx'],
#}

service { 'nginx' :
  ensure => running,
  enable => true,
}


}
