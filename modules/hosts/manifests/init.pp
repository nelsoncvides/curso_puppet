class hosts {
  host { 'testing.puppetlabs.vm' : 
    ensure => present,
    ip     => '127.0.0.1'
  }
}
