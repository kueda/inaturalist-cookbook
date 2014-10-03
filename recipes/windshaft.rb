#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: windshaft
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

include_recipe "sudo"
include_recipe "postgresql::client"
include_recipe "varnish"
include_recipe "nodejs"
include_recipe "nodejs::npm"
include_recipe "redisio"
include_recipe "redisio::enable"

%w(postgis postgresql-9.3-postgis-2.1 nodejs libgeos-dev libgeos++-dev zip gdal-bin default-jre memcached vim nodejs).each do |pkg|
  package pkg
end

apt_repository 'mapnik' do
  uri 'ppa:mapnik/nightly-2.3'
  distribution 'trusty'
end

%w(libmapnik libmapnik-dev mapnik-utils python-mapnik mapnik-input-plugin-postgis).each do |pkg|
  package pkg
end

git "/home/vagrant/windshaft" do
  repository "https://github.com/pleary/Windshaft-inaturalist.git"
  reference "vagrant_test"
  action :sync
  user "vagrant"
  group "vagrant"
end

template "/home/vagrant/windshaft/config.js" do
  source "config.js.erb"
  owner "vagrant"
  group "vagrant"
end

nodejs_npm "forever"

template "/etc/init/windshaft.conf" do
  source "windshaft.conf.erb"
  owner "root"
  group "root"
end
