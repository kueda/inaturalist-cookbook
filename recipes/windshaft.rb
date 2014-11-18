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

include_recipe "inaturalist-cookbook::inaturalist_user"

if node["windshaft"]["install_directory"]

  include_recipe "postgresql::client"
  include_recipe "nodejs"
  include_recipe "nodejs::npm"

  %w(postgis postgresql-9.3-postgis-2.1 nodejs libgeos-dev libgeos++-dev zip
     gdal-bin default-jre memcached vim nodejs).each do |pkg|
    package pkg
  end

  apt_repository "mapnik" do
    uri "ppa:mapnik/nightly-2.3"
    distribution "trusty"
  end

  %w(libmapnik libmapnik-dev mapnik-utils python-mapnik mapnik-input-plugin-postgis
     libprotobuf8 libprotobuf-dev protobuf-compiler).each do |pkg|
    package pkg
  end

  group node["windshaft"]["group"] do
    system true
    action :create
  end

  user node["windshaft"]["user"] do
    supports :manage_home => true
    group node["windshaft"]["group"]
    home "/home/#{ node["windshaft"]["user"] }"
    shell "/bin/bash"
    action :create
  end

  directory node["windshaft"]["install_directory"] do
    owner node["windshaft"]["user"]
    group node["windshaft"]["group"]
    action :create
    recursive true
  end

  git node["windshaft"]["install_directory"] do
    repository node["windshaft"]["git_repo"]
    reference node["windshaft"]["git_reference"]
    action :sync
    user node["windshaft"]["user"]
    group node["windshaft"]["group"]
  end

  template "#{ node["windshaft"]["install_directory"] }/config.js" do
    source "windshaft_config.js.erb"
    owner node["windshaft"]["user"]
    group node["windshaft"]["group"]
    not_if { File.exists?("#{ node["windshaft"]["install_directory"] }/config.js") }
  end

  nodejs_npm "forever"

  template "/etc/init/windshaft.conf" do
    source "windshaft_init.conf.erb"
    owner "root"
    group "root"
  end

  cookbook_file "#{ node["windshaft"]["install_directory"] }/node_modules.tar.gz" do
    source "windshaft_node_modules.tar.gz"
    owner node["windshaft"]["user"]
    group node["windshaft"]["group"]
    not_if { Dir.exists?("#{ node["windshaft"]["install_directory"] }/node_modules") }
    notifies :run, "script[uncompress_node_modules]", :immediately
  end

  script "uncompress_node_modules" do
    interpreter "bash"
    user node["windshaft"]["user"]
    cwd node["windshaft"]["install_directory"]
    code <<-EOH
    tar -zxf node_modules.tar.gz
    rm #{ node["windshaft"]["install_directory"] }/node_modules.tar.gz
    EOH
    only_if { File.exists?("#{ node["windshaft"]["install_directory"] }/node_modules.tar.gz") }
    not_if { Dir.exists?("#{ node["windshaft"]["install_directory"] }/node_modules") }
    action :nothing
  end

end
