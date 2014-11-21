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

all_nodes = [ ]
postgresql_nodes = [ ]
memcached_nodes = [ ]
nfs_nodes = [ ]
sphinx_nodes = [ ]
windshaft_load_balancers = [ ]

unless Chef::Config[:solo]
  search(:node, "chef_environment:#{node.chef_environment}").each do |n|
    ipaddress =
      if n.has_key?("cloud")
        n["cloud"]["local_ipv4"]
      elsif ips = n[:network][:interfaces][:eth1][:addresses].detect{ |k,v| v[:family] == "inet" }
        ips.first
      else
        n["ipaddress"]
      end
    this_node = { name: n["hostname"], ipaddress: ipaddress, public_ipaddress: n["ipaddress"] }
    all_nodes << this_node
    postgresql_nodes << this_node if n["roles"].include?("postgresql_server")
    memcached_nodes << this_node if n["roles"].include?("memcached_server")
    nfs_nodes << this_node if n["roles"].include?("nfs_server")
    sphinx_nodes << this_node if n["roles"].include?("sphinx_server")
    windshaft_load_balancers << this_node if n["roles"].include?("windshaft_load_balancer")
  end
end

node.default["all_nodes"] = all_nodes.sort_by{ |n| n[:name] }
node.default["postgresql_nodes"] = postgresql_nodes.sort_by{ |n| n[:name] }
node.default["memcached_nodes"] = memcached_nodes.sort_by{ |n| n[:name] }
node.default["nfs_nodes"] = nfs_nodes.sort_by{ |n| n[:name] }
node.default["sphinx_nodes"] = sphinx_nodes.sort_by{ |n| n[:name] }
node.default["windshaft_load_balancers"] = windshaft_load_balancers.sort_by{ |n| n[:name] }

include_recipe "iptables"
include_recipe "fail2ban"
iptables_rule "firewall_a_first"
iptables_rule "firewall_b_common"
iptables_rule "firewall_z_last"

service "fail2ban" do
  subscribes :restart, "execute[rebuild-iptables]", :delayed
end
