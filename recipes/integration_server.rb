#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: integration_server
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

include_recipe "inaturalist-cookbook::memcached_server"
include_recipe "inaturalist-cookbook::postgresql_server"
include_recipe "inaturalist-cookbook::app_server"
include_recipe "postfix::server"

# bash script to download and import the latest production dump
template "/home/inaturalist/postgresql_refresh.sh" do
  source "postgresql_refresh.sh.erb"
  owner "inaturalist"
  group "inaturalist"
  mode "0700"
end
