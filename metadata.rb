name             "inaturalist-cookbook"
maintainer       "iNaturalist"
maintainer_email "patrick.r.leary@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures inaturalist-cookbook"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.8"

%w( git
    postgresql
    apt
    sudo
    vim
    rvm
    git
    curl
    build-essential
    varnish
    nodejs
    redisio
    apt
    omnibus_updater
    timezone
    chef-client
    chef-server
    collectd
    collectd_plugins
    apache2
    graphite
    statsd
    monitor
    postfix
    users
    grafana
    fail2ban
    iptables
    hostsfile
    sphinx).each do |cb|
  depends cb
end
