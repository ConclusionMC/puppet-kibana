# kibana

[![Build Status](https://travis-ci.org/cristifalcas/puppet-kibana.png?branch=master)](https://travis-ci.org/cristifalcas/puppet-kibana)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Development - Guide for contributing to the module](#development)

## Overview

This repo is a fork of cristifalcas's kibana repo (https://github.com/cristifalcas/puppet-kibana). It has been forked and modified because the original repo had dependencies to apache, nginx and htpasswd modules. And in our opinion those dependencies should not be there. If you want to use apache or nginx as a proxy, install that module seperate (define it in a role of profile) and assign it to a node using hiera. It is not a depdency of this module because it runs fine without it. It's just a design choice.

There was also a small bug in the original repo. If the pidfile was defined in the config file, kibana wouldn't start and there was no option to remove the pidfile properly using this module. So a small redesign was needed to make it optional.

Kibana is an open source analytics and visualization platform designed to work with Elasticsearch.
You use Kibana to search, view, and interact with data stored in Elasticsearch indices.
You can easily perform advanced data analysis and visualize your data in a variety of charts, tables, and maps.

This module is for kibana 4.4

## Usage

Your package should be available via a repo. This module doesn't manage a repo. It asumes it is available. (pulp or something else you prefer)

This installs kibana using the defauls specified in the params.pp file:

    include kibana

The default parameters can be easily overwritten using hiera

    kibana::server_host: '127.0.0.1'
    kibana::server_port: 5601
    kibana::elasticsearch_url: 'http://elastic.example.com:9200'

### Using a proxy

As stated above, the apache and nginx modules are no longer a dependency of this module, so if you still want to use them, you need to install them seperately.
This is how we use them:

In our Puppetfile (we use librarian-puppet) we add this rule:
    mod 'jfryman-nginx', '0.3.0'
and then install it:
    $ librarian-puppet install
and add the module to our .gitignore.

Create a role and profile for both kibana and nginx:
modules/role/manifests/nginx/server.pp:
    class role::nginx::server
    {
      include profile::nginx::server
    }
modules/profile/manifests/nginx/server.pp:
    class profile::nginx::server
    {
      class { 'nginx':
      }
      $listenport = '80'
      $iptable_entries = {
        '200 Nginx http' => {
          chain  => $::input_chain_name,
          proto  => 'tcp',
          action => 'accept',
          dport  => $listenport
        }
      }
      create_resources('firewall', $iptable_entries)
      selboolean { 'httpd_can_network_connect':
        persistent => true,
        value      => 'on'
      }
    }
modules/role/manifests/kibana/server.pp:
    class role::kibana::server
    {
      include profile::kibana::server
    }
modules/profile/manifests/kibana/server.pp:
    class profile::kibana::server
    {
      class { 'kibana':
      }
      $listenport = '5601'
      $iptable_entries = {
        '200 Kibana server' => {
          chain  => $::input_chain_name,
          proto  => 'tcp',
          action => 'accept',
          dport  => $listenport
        }
      }
      create_resources('firewall', $iptable_entries)
    }

We use a global site.pp which includes the roles for each node.yaml:
    hiera_include('roles')

And in the node.yaml we have this:
    ---
    roles:
      - role::kibana::server
      - role::nginx::server

    kibana::server_host: '127.0.0.1'
    kibana::server_port: 5601
    kibana::elasticsearch_url: 'http://elastic01.example.com:9200'

    nginx::manage_repo: false
    nginx::config:
      vhost_purge: true
      confd_purge: true
    nginx::nginx_vhosts:
      'kibana01.example.com':
        listen_port: 80
        rewrite_to_https: false
        use_default_location: false
    nginx::nginx_locations:
      root:
        ensure: 'present'
        proxy: "http://%{kibana::server_host}:%{kibana::server_port}"
        vhost: 'kibana01.example.com'
        location: '/'
        proxy_set_header:
          - 'Upgrade $http_upgrade'
          - "Connection 'upgrade'"

If you don't want multiple roles on 1 node you could allways include the role::nginx::server in your kibana server profile

## Development

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes
