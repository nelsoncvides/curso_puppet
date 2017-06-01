# == Class:
# 'nginx':
class { 'nginx':
  # resources
  root => '/var/www',
  highperf => false,
}
