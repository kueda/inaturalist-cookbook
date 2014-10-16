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

execute "sudo -u vagrant cp /vagrant/shared/rails/inaturalist/config/config.yml.example /vagrant/shared/rails/inaturalist/config/config.yml" do
  only_if { File.exists?("/vagrant/shared/rails/inaturalist/config/config.yml.example") }
  not_if { File.exists?("/vagrant/shared/rails/inaturalist/config/config.yml") }
  notifies :run, "script[edit_config_yml]", :delayed
end

execute "sudo -u vagrant cp /vagrant/shared/rails/inaturalist/config/database.yml.example /vagrant/shared/rails/inaturalist/config/database.yml" do
  only_if { File.exists?("/vagrant/shared/rails/inaturalist/config/database.yml.example") }
  not_if { File.exists?("/vagrant/shared/rails/inaturalist/config/database.yml") }
  notifies :run, "script[edit_database_yml]", :delayed
end

execute "sudo -u vagrant cp /vagrant/shared/rails/inaturalist/config/gmaps_api_key.yml.example /vagrant/shared/rails/inaturalist/config/gmaps_api_key.yml" do
  only_if { File.exists?("/vagrant/shared/rails/inaturalist/config/gmaps_api_key.yml.example") }
  not_if { File.exists?("/vagrant/shared/rails/inaturalist/config/gmaps_api_key.yml") }
end

execute "sudo -u vagrant cp /vagrant/shared/rails/inaturalist/config/smtp.yml.example /vagrant/shared/rails/inaturalist/config/smtp.yml" do
  only_if { File.exists?("/vagrant/shared/rails/inaturalist/config/smtp.yml.example") }
  not_if { File.exists?("/vagrant/shared/rails/inaturalist/config/smtp.yml") }
end

execute "sudo -u vagrant cp /vagrant/shared/rails/inaturalist/config/sphinx.yml.example /vagrant/shared/rails/inaturalist/config/sphinx.yml" do
  only_if { File.exists?("/vagrant/shared/rails/inaturalist/config/sphinx.yml.example") }
  not_if { File.exists?("/vagrant/shared/rails/inaturalist/config/sphinx.yml") }
end

script "edit_config_yml" do
  interpreter "bash"
  user "vagrant"
  cwd "/vagrant/shared/rails/inaturalist"
  code <<-EOH
  sed -i 's/http:\\\/\\\/www\\\.yoursite\\\.com/http:\\\/\\\/localhost:3000/g' /vagrant/shared/rails/inaturalist/config/config.yml
  sed -i 's/yourbucketname/staticdev\\\.inaturalist\\\.org/g' /vagrant/shared/rails/inaturalist/config/config.yml
  EOH
  only_if { File.exists?("/vagrant/shared/rails/inaturalist/config/config.yml") }
  not_if "grep staticdev /vagrant/shared/rails/inaturalist/config/config.yml"
  action :nothing
end

script "edit_database_yml" do
  interpreter "bash"
  user "vagrant"
  cwd "/vagrant/shared/rails/inaturalist"
  code <<-EOH
  sed -i 's/host: localhost/host: 192.168.50.7/' /vagrant/shared/rails/inaturalist/config/database.yml
  sed -i 's/username: you/username: postgres/' /vagrant/shared/rails/inaturalist/config/database.yml
  sed -i 's/template_postgis/template_postgis\\\n  password: #{node[:postgresql][:password][:postgres]}/' /vagrant/shared/rails/inaturalist/config/database.yml
  EOH
  only_if { File.exists?("/vagrant/shared/rails/inaturalist/config/database.yml") }
  not_if "grep #{node[:postgresql][:password][:postgres]} /vagrant/shared/rails/inaturalist/config/database.yml"
  action :nothing
  notifies :run, "rvm_shell[create_databases]", :immediate
end


rvm_shell "create_databases" do
  ruby_string "ruby-1.9.3@inaturalist"
  user "vagrant"
  cwd "/vagrant/shared/rails/inaturalist"
  code <<-EOH
  rake db:setup
  rake db:setup RAILS_ENV=test
  EOH
  action :nothing
end
