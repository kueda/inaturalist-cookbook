#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: development
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

include_recipe "postgresql::client"

%w(nodejs libgeos-dev libgeos++-dev zip gdal-bin default-jre memcached vim).each do |pkg|
  package pkg
end

group node["inaturalist"]["group"] do
  system true
  action :create
end

user node["inaturalist"]["user"] do
  supports :manage_home => true
  group node["inaturalist"]["group"]
  home "/home/#{ node["inaturalist"]["user"] }"
  shell "/bin/bash"
  action :create
end

include_recipe "rvm::user"

directory node["inaturalist"]["install_directory"] do
  owner node["inaturalist"]["user"]
  group node["inaturalist"]["group"]
  action :create
  recursive true
end

git node["inaturalist"]["install_directory"] do
  repository node["inaturalist"]["git_repo"]
  reference node["inaturalist"]["git_reference"]
  action :sync
  user node["inaturalist"]["user"]
  group node["inaturalist"]["group"]
  notifies :run, "script[install_wkhtmltopdf]", :immediately
end

file "#{ node["inaturalist"]["install_directory"] }/.ruby-version" do
  content node["rvm"]["user_installs"].first["rubies"].first
  owner node["inaturalist"]["user"]
  group node["inaturalist"]["group"]
end

file "#{ node["inaturalist"]["install_directory"] }/.ruby-gemset" do
  content "inaturalist"
  owner node["inaturalist"]["user"]
  group node["inaturalist"]["group"]
end

cookbook_file "/home/#{ node["inaturalist"]["user"] }/.rspec" do
  source "rspec"
  owner node["inaturalist"]["user"]
  group node["inaturalist"]["group"]
end

script "install_wkhtmltopdf" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  wget http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-static-amd64.tar.bz2
  tar xvjf wkhtmltopdf-0.9.9-static-amd64.tar.bz2
  sudo mv wkhtmltopdf-amd64 /usr/local/bin/wkhtmltopdf
  sudo chmod +x /usr/local/bin/wkhtmltopdf
  EOH
  not_if { File.exists?("/usr/local/bin/wkhtmltopdf") }
  action :nothing
end

rvm_shell "bundle-install" do
  ruby_string node["rvm"]["user_installs"].first["default_ruby"]
  user node["inaturalist"]["user"]
  cwd node["inaturalist"]["install_directory"]
  code "bundle install"
end

include_recipe "inaturalist-cookbook::_development_config"
