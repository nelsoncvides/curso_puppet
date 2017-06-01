# Instalar wordpress
# 1) Apache - puppet module install puppetlabs/apache
# 2) PHP - é uma classe do modulo apache
# 3) Mysql - puppet module install puppetlabs/mysql
# 4) Wordpress - puppet module install hunner/wordpress
class profile::wordpress {

  include apache
  include apache::mod::php

  class { '::mysql::server':
    root_password => 'strongpassword',
  }

  include mysql::bindings::php

  class { 'wordpress':
    version => '4.7.5',
    install_dir => '/var/www/html'
  }

}
