#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: collectd_server
#
# Copyright 2014, iNaturalist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

iptables_rule "firewall_b_collectd_server"

include_recipe "collectd::server"
include_recipe "collectd::collectd_web"
include_recipe "collectd_plugins"
include_recipe "collectd_plugins::load"

template "/etc/apache2/sites-available/collectd_web.conf" do
  source "collectd_web.conf.erb"
  owner "root"
  group "root"
  mode "644"
end

package "apache2-utils"

apache_site "collectd_web"

apache_module "cgi"

collectd_plugin "write_graphite" do
  template "write_graphite.conf.erb"
end

collectd_plugin "logfile" do
  options log_level: "info", file: "/var/log/collectd.log", timestamp: true
end
