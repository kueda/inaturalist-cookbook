#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: app_server
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

# Set configs based on node searches
postgres_nodes = custom_search_nodes("chef_environment:#{node.chef_environment} AND recipes:inaturalist-cookbook\\:\\:postgresql_server")
unless blank?(postgres_nodes)
  node.default["inaturalist"]["db"]["host"] = postgres_nodes.first["ipaddress"]
end
memcached_nodes = custom_search_nodes("chef_environment:#{node.chef_environment} AND recipes:inaturalist-cookbook\\:\\:memcached_server")
unless blank?(memcached_nodes)
  node.default["inaturalist"]["memcached_host"] = memcached_nodes.first["ipaddress"]
end

node.default["inaturalist"]["db"]["host"] ||= node_data(node)["ipaddress"]
node.default["inaturalist"]["memcached_host"] ||= node_data(node)["ipaddress"]

# Install packages
%w(nodejs libgeos-dev libgeos++-dev zip gdal-bin default-jre).each do |pkg|
  package pkg
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
end

include_recipe "inaturalist-cookbook::inaturalist_user"
include_recipe "postgresql::client"

# RVM
# If `rvm_default_ruby[ruby-1.9.3-p547] action create` fails with
# undefined method `chomp' for nil:NilClass then it could be that
# https://get.rvm.io is down for some reason. Try running chef-client again
include_recipe "rvm::system"

rvm_gem "passenger" do
  action :install
  version node["nginx"]["passenger"]["version"]
end

# NGINX
include_recipe "nginx::commons_dir"
include_recipe "nginx::passenger"
include_recipe "nginx::source"

template "#{ node['nginx']['dir'] }/sites-available/inaturalist" do
  source "inaturalist-site.erb"
  owner "root"
  group node["root_group"]
  mode "0644"
  notifies :reload, "service[nginx]"
end

template "#{ node['nginx']['dir'] }/sites-available/bypass" do
  source "inaturalist-site-bypass.erb"
  owner "root"
  group node["root_group"]
  mode "0644"
  notifies :reload, "service[nginx]"
end

if node["inaturalist"]["site_htpasswd"]
  file "#{ node['nginx']['dir'] }/.htpasswd" do
    content node["inaturalist"]["site_htpasswd"]
    owner "root"
    group node["root_group"]
    mode "0644"
    notifies :reload, "service[nginx]"
  end
end

# set the GC environment variables for passenger through RVM
template "/home/inaturalist/.rvmrc" do
  source "rvmrc.erb"
  owner "inaturalist"
  group "inaturalist"
  mode "0600"
end

# only enable the nginx config that responds to connections
# production app servers will want to enable the bypass site
nginx_site "inaturalist" do
  enable true
end

# Sphinx
include_recipe "sphinx"

node.default["inaturalist"]["sphinx"]["bin_path"] =
  File.exists?("/usr/local/bin/searchd") ? "/usr/local/bin/" : "/usr/bin/"

# Create directory structure for Rails/capistrano app
[ "/home/inaturalist/deployment",
  "/home/inaturalist/deployment/production",
  "/home/inaturalist/deployment/production/releases",
  "/home/inaturalist/deployment/production/shared",
  "/home/inaturalist/deployment/production/shared/log",
  "/home/inaturalist/deployment/production/shared/pids",
  "/home/inaturalist/deployment/production/shared/system",
  "/home/inaturalist/deployment/production/shared/system/attachments",
  "/home/inaturalist/deployment/production/shared/system/cache",
  "/home/inaturalist/deployment/production/shared/system/db",
  "/home/inaturalist/deployment/production/shared/system/db/sphinx",
  "/home/inaturalist/deployment/production/shared/system/page_cache",
  "/home/inaturalist/deployment/production/shared/system/page_cache/observations"
].each do |dir|
  directory dir do
    owner "inaturalist"
    group "inaturalist"
    action :create
  end
end

# Create Rails config files
[ "config.yml",
  "database.yml",
  "s3.yml",
  "settings.yml",
  "smtp.yml",
  "sphinx.yml"
].each do |conf|
  template "/home/inaturalist/deployment/#{ conf }" do
    source "#{ conf }.erb"
    owner "inaturalist"
    group "inaturalist"
    mode "0600"
    helpers(Inaturalist::Helpers)
  end
end

# schedules might vary from machine-to-machine. We just want to
# make sure every app has one for now, not overwrite an existing one
template "/home/inaturalist/deployment/schedule.rb" do
  source "schedule.rb.erb"
  owner "inaturalist"
  group "inaturalist"
  mode "0600"
  not_if { File.exists?("/home/inaturalist/deployment/schedule.rb") }
end
