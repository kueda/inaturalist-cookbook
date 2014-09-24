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

include_recipe "sudo"
include_recipe "rvm::user"
include_recipe "postgresql::server"
include_recipe "postgresql::client"

%w(postgis postgresql-9.3-postgis-2.1 nodejs libgeos-dev libgeos++-dev zip gdal-bin).each do |pkg|
  package pkg
end

directory "/home/vagrant/rails" do
  owner "vagrant"
  group "vagrant"
end

git "/home/vagrant/rails/inaturalist" do
  repository "https://github.com/pleary/inaturalist.git"
  reference "specs"
  action :sync
  user "vagrant"
  group "vagrant"
  notifies :run, 'script[install_dependencies]', :immediately
end

file "/home/vagrant/rails/inaturalist/.ruby-version" do
  content "ruby-1.9.3"
  owner "vagrant"
  group "vagrant"
end

file "/home/vagrant/rails/inaturalist/.ruby-gemset" do
  content "inaturalist"
  owner "vagrant"
  group "vagrant"
end

template "/home/vagrant/.rspec" do
  source "rspec.erb"
  owner "vagrant"
  group "vagrant"
end

script "install_dependencies" do
  interpreter "bash"
  user "vagrant"
  cwd "/home/vagrant"
  code <<-EOH
  wget http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-static-amd64.tar.bz2
  tar xvjf wkhtmltopdf-0.9.9-static-amd64.tar.bz2
  sudo mv wkhtmltopdf-amd64 /usr/local/bin/wkhtmltopdf
  sudo chmod +x /usr/local/bin/wkhtmltopdf
  sudo -u postgres createdb template_postgis
  sudo -u postgres psql template_postgis -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis'"
  sudo -u postgres psql template_postgis < /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql
  sudo -u postgres psql template_postgis < /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql
  EOH
  not_if do
    File.exist?("/usr/local/bin/wkhtmltopdf")
  end
  action :nothing
end
