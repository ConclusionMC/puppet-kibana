# == Class: kibana::configure
#
# This class configures kibana.  It should not be directly called.
#
class kibana::config {
  file { '/opt/kibana/config/kibana.yml':
    ensure  => file,
    content => template("${module_name}/kibana.yml.erb"),
    mode    => '0644',
  }
  file { '/var/run/kibana':
    ensure => directory,
    owner  => 'kibana',
    group  => 'kibana'
  }
  file { '/var/log/kibana':
    ensure => directory,
    owner  => 'kibana',
    group  => 'kibana'
  }
}
