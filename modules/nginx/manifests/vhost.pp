define nginx::vhost (
  $port = '80',
  $servername = $title,
  $docroot = "${nginx::docroot}/vhosts/${title}",
) {
  File {
    owner => $nginx::owner,
    group => $nginx::group,
    mode => '0664',
  }

host { $title:
  ip => $facts['ipaddress'],
}

file { "nginx-vhost-${title}":
  ensure  => file,
  path    => "${nginx::blockdir}/${title}.conf",
  content => epp('nginx/vhost.conf.epp',
                  {
                    port => $port,
                    docroot => $docroot,
                    servername => $servername,
                    title => $title,
                    }),
  notify => Service['nginx'],
}

file { $docroot:
  ensure => directory,
  before => File["nginx-vhost-${title}"],
}

file { "${docroot}/index.html":
  ensure => file,
  content => epp('nginx/index.html.epp',
                  {
                    servername => $servername
                    }),
 }
}
