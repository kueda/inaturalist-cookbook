#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: _sensu_checks_and_handlers
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

include_recipe "inaturalist-cookbook::_sensu_ponymailer_handler"
include_recipe "inaturalist-cookbook::_sensu_slack_handler"
include_recipe "inaturalist-cookbook::_sensu_remediation_handler"
include_recipe "inaturalist-cookbook::_sensu_graphite_handler"

# check-chef-nodes
sensu_gem "chef"
cookbook_file "/etc/sensu/plugins/check-chef-nodes.rb" do
  source "sensu/plugins/check-chef-nodes.rb"
  mode 0755
end

# check-disk
cookbook_file "/etc/sensu/plugins/check-disk.rb" do
  source "sensu/plugins/check-disk.rb"
  mode 0755
end

# check-load
cookbook_file "/etc/sensu/plugins/check-load.rb" do
  source "sensu/plugins/check-load.rb"
  mode 0755
end

# check-ram
cookbook_file "/etc/sensu/plugins/check-ram.rb" do
  source "sensu/plugins/check-ram.rb"
  mode 0755
end

# check-swap
cookbook_file "/etc/sensu/plugins/check-swap.rb" do
  source "sensu/plugins/check-swap.rb"
  mode 0755
end

# metrics-postgresql
sensu_gem "pg"
cookbook_file "/etc/sensu/plugins/metrics-postgresql.rb" do
  source "sensu/plugins/metrics-postgresql.rb"
  mode 0755
end

# metrics-vmstat
cookbook_file "/etc/sensu/plugins/metrics-vmstat.rb" do
  source "sensu/plugins/metrics-vmstat.rb"
  mode 0755
end
