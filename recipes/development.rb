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

include_recipe "rvm::user"
include_recipe "postgresql::client"

%w(nodejs libgeos-dev libgeos++-dev zip gdal-bin default-jre memcached vim).each do |pkg|
  package pkg
end

directory "/vagrant/shared/rails" do
  owner "vagrant"
  group "vagrant"
  recursive true
end

git "/vagrant/shared/rails/inaturalist" do
  repository "https://github.com/inaturalist/inaturalist.git"
  reference "master"
  action :sync
  user "vagrant"
  group "vagrant"
  notifies :run, 'script[install_wkhtmltopdf]', :immediately
end

file "/vagrant/shared/rails/inaturalist/.ruby-version" do
  content "ruby-1.9.3"
  owner "vagrant"
  group "vagrant"
end

file "/vagrant/shared/rails/inaturalist/.ruby-gemset" do
  content "inaturalist"
  owner "vagrant"
  group "vagrant"
end

template "/home/vagrant/.rspec" do
  source "rspec.erb"
  owner "vagrant"
  group "vagrant"
end

script "install_wkhtmltopdf" do
  interpreter "bash"
  user "vagrant"
  cwd "/home/vagrant"
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
  ruby_string "ruby-1.9.3@inaturalist"
  user "vagrant"
  cwd "/vagrant/shared/rails/inaturalist"
  code "bundle install"
end
