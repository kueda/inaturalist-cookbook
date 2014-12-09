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
node.run_state["all_nodes"] = all_nodes
node.run_state["postgresql_nodes"] = all_nodes.select{ |n|
  n["roles"].include?("postgresql_server") }
node.run_state["memcached_nodes"] = all_nodes.select{ |n|
  n["roles"].include?("memcached_server") }
node.run_state["nfs_nodes"] = all_nodes.select{ |n|
  n["roles"].include?("nfs_server") }
node.run_state["sphinx_nodes"] = all_nodes.select{ |n|
  n["roles"].include?("sphinx_server") }
node.run_state["windshaft_load_balancers"] = all_nodes.select{ |n|
  n["roles"].include?("windshaft_load_balancer") }

include_recipe "iptables"
include_recipe "fail2ban"
iptables_rule "firewall_a_first"
iptables_rule "firewall_b_common"
iptables_rule "firewall_z_last"

service "fail2ban" do
  subscribes :restart, "execute[rebuild-iptables]", :delayed
end
