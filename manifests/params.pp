class kibana::params {
  $ensure = 'present'

  $server_port = 5601
  $server_host = '127.0.0.1'
  $server_base_path = ''
  $server_max_payload_bytes = 1048576
  $server_name = $::fqdn
  $elasticsearch_url = 'http://localhost:9200'
  $elasticsearch_preserve_host = true
  $kibana_index = '.kibana'
  $kibana_default_app_id = 'discover'
  $elasticsearch_username = undef
  $elasticsearch_password = undef
  $server_ssl_enable = false
  $server_ssl_cert = "${::settings::ssldir}/certs/${::clientcert}.pem"
  $server_ssl_key = "${::settings::ssldir}/private_keys/${::clientcert}.pem"
  $elasticsearch_ssl_enable = false
  $elasticsearch_ssl_cert = "${::settings::ssldir}/certs/${::clientcert}.pem"
  $elasticsearch_ssl_key = "${::settings::ssldir}/private_keys/${::clientcert}.pem"
  $elasticsearch_ssl_ca = "${::settings::ssldir}/certs/ca.pem"
  $elasticsearch_ssl_verify = true
  $elasticsearch_ping_timeout = 1500
  $elasticsearch_request_timeout = 300000
  $elasticsearch_shard_timeout = 0
  $elasticsearch_startup_timeout = 5000
  $pid_file = '/var/run/kibana.pid'
  $logging_dest = '/var/log/kibana/kibana.log'
  $logging_silent = false
  $logging_quiet = false
  $logging_verbose = false
}
