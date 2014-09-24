#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: _development_config
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

execute "cp /home/vagrant/rails/inaturalist/config/config.yml.example /home/vagrant/rails/inaturalist/config/config.yml" do
  only_if { File.exist?("/home/vagrant/rails/inaturalist/config/config.yml.example") }
  notifies :run, 'script[edit_config_yml]', :delayed
end

execute "cp /home/vagrant/rails/inaturalist/config/database.yml.example /home/vagrant/rails/inaturalist/config/database.yml" do
  only_if { File.exist?("/home/vagrant/rails/inaturalist/config/database.yml.example") }
  notifies :run, 'script[edit_database_yml]', :delayed
end

execute "cp /home/vagrant/rails/inaturalist/config/gmaps_api_key.yml.example /home/vagrant/rails/inaturalist/config/gmaps_api_key.yml" do
  only_if { File.exist?("/home/vagrant/rails/inaturalist/config/gmaps_api_key.yml.example") }
end

execute "cp /home/vagrant/rails/inaturalist/config/smtp.yml.example /home/vagrant/rails/inaturalist/config/smtp.yml" do
  only_if { File.exist?("/home/vagrant/rails/inaturalist/config/smtp.yml.example") }
end

execute "cp /home/vagrant/rails/inaturalist/config/sphinx.yml.example /home/vagrant/rails/inaturalist/config/sphinx.yml" do
  only_if { File.exist?("/home/vagrant/rails/inaturalist/config/sphinx.yml.example") }
end

script "edit_config_yml" do
  interpreter "bash"
  user "vagrant"
  cwd "/home/vagrant/rails/inaturalist"
  code <<-EOH
  sed -i 's/http:\\\/\\\/www\\\.yoursite\\\.com/http:\\\/\\\/localhost:3000/g' /home/vagrant/rails/inaturalist/config/config.yml
  sed -i 's/yourbucketname/staticdev\\\.inaturalist\\\.org/g' /home/vagrant/rails/inaturalist/config/config.yml
  EOH
  action :nothing
end

script "edit_database_yml" do
  interpreter "bash"
  user "vagrant"
  cwd "/home/vagrant/rails/inaturalist"
  code <<-EOH
  sed -i 's/you/postgres/' /home/vagrant/rails/inaturalist/config/database.yml
  sed -i 's/template_postgis/template_postgis\\\n  password: 0928743rwhf0834fh/' /home/vagrant/rails/inaturalist/config/database.yml
  EOH
  action :nothing
end
