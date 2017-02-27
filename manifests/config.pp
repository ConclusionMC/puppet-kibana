# == Class: kibana::configure
#
# This class configures kibana.  It should not be directly called.
#
class kibana::config {
  file { '/etc/kibana/kibana.yml':
    ensure  => file,
    content => template("${module_name}/kibana.yml.erb"),
    mode    => '0644',
  }

  file { $kibana::pid_file:
    ensure => file,
    owner  => 'kibana',
    group  => 'kibana',
    before => Service['kibana'],
  }

  file { '/etc/tmpfiles.d/kibana.conf':
    ensure  => file,
    content => template("${module_name}/kibana.conf.erb"),
    owner   => 'kibana',
    group   => 'kibana',
    before  => Service['kibana'],
  }

  file { '/var/log/kibana':
    ensure => directory,
    owner  => 'kibana',
    group  => 'kibana',
    before  => Service['kibana']
  }

}
