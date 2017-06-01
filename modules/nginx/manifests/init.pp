class nginx {

case $facts['os']['family']{
  'redhat', 'debian' : {
    $package = 'nginx'
    $owner = 'root'
    $group = 'root'
    $docroot = '/var/www'
    $confdir = '/etc/nginx'
    $blockdir = '/etc/nginx/conf.d'
    $logdir = '/var/log/nginx'
  }
  'windows' : {
    $package = 'nginx-service'
    $owner = 'Administrator'
    $group = 'Administrators'
    $docroot = 'C:/ProgramData/nginx/html'
    $confdir = 'C:/ProgramData/nginx/conf'
    $blockdir = 'C:/ProgramData/nginx/conf.d'
    $logdir = 'C:/ProgramData/nginx/log'
  }
  default : {
    fail("Module ${module_name} is not supported on ${facts['os']['family']}")
  }
}

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
