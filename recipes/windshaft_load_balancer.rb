#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: windshaft_load_balancer
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

all_windshaft_nodes = [ ]
unless Chef::Config[:solo]
  search(:node, "role:windshaft_server").each do |n|
    ipaddress = n.has_key?("cloud") ? n["cloud"]["local_ipv4"] : n["ipaddress"]
    all_windshaft_nodes << { name: n["hostname"], ipaddress: ipaddress, public_ipaddress: n["ipaddress"] }
  end
end

if all_windshaft_nodes.empty?
  node.default["windshaft_servers"] = [ { name: "localhost", ipaddress: "localhost" } ]
else
  node.default["windshaft_servers"] = all_windshaft_nodes.sort_by{ |n| n[:name] }
end

iptables_rule "firewall_b_windshaft_load_balancer"

include_recipe "varnish"
include_recipe "redisio"
include_recipe "redisio::enable"
