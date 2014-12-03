#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: firewall
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

all_nodes = custom_search_nodes("*")
node.default["all_nodes"] = all_nodes
node.default["postgresql_nodes"] = all_nodes.select{ |n|
  n[:roles].include?("postgresql_server") ||
  n[:recipes].include?("inaturalist-cookbook::postgresql_server") }
node.default["memcached_nodes"] = all_nodes.select{ |n|
  n[:roles].include?("memcached_server") ||
  n[:recipes].include?("inaturalist-cookbook::memcached_server") }
node.default["nfs_nodes"] = all_nodes.select{ |n|
  n[:roles].include?("nfs_server") ||
  n[:recipes].include?("inaturalist-cookbook::nfs_server") }
node.default["sphinx_nodes"] = all_nodes.select{ |n|
  n[:roles].include?("sphinx_server") ||
  n[:recipes].include?("inaturalist-cookbook::sphinx_server") }
node.default["windshaft_load_balancers"] = all_nodes.select{ |n|
  n[:roles].include?("windshaft_load_balancer") ||
  n[:recipes].include?("inaturalist-cookbook::windshaft_load_balancer") }

include_recipe "iptables"
include_recipe "fail2ban"
iptables_rule "firewall_a_first"
iptables_rule "firewall_b_common"
iptables_rule "firewall_z_last"

service "fail2ban" do
  subscribes :restart, "execute[rebuild-iptables]", :delayed
end
