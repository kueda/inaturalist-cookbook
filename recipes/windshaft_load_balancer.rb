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

node.default["windshaft_servers"] = custom_search_nodes("role:windshaft_server")
node.default["windshaft_servers"] ||= [ { name: "localhost", ipaddress: "localhost" } ]

iptables_rule "firewall_b_windshaft_load_balancer"

include_recipe "varnish"
include_recipe "redisio"
include_recipe "redisio::enable"
