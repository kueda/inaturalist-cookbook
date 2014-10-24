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

execute "sudo -u #{ node["inaturalist"]["user"] } cp #{ node["inaturalist"]["install_directory"] }/config/config.yml.example #{ node["inaturalist"]["install_directory"] }/config/config.yml" do
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/config.yml.example") }
  not_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/config.yml") }
  notifies :run, "script[edit_config_yml]", :delayed
end

execute "sudo -u #{ node["inaturalist"]["user"] } cp #{ node["inaturalist"]["install_directory"] }/config/database.yml.example #{ node["inaturalist"]["install_directory"] }/config/database.yml" do
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/database.yml.example") }
  not_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/database.yml") }
  notifies :run, "script[edit_database_yml_password]", :delayed
  notifies :run, "script[edit_database_yml]", :delayed
end

execute "sudo -u #{ node["inaturalist"]["user"] } cp #{ node["inaturalist"]["install_directory"] }/config/gmaps_api_key.yml.example #{ node["inaturalist"]["install_directory"] }/config/gmaps_api_key.yml" do
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/gmaps_api_key.yml.example") }
  not_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/gmaps_api_key.yml") }
end

execute "sudo -u #{ node["inaturalist"]["user"] } cp #{ node["inaturalist"]["install_directory"] }/config/smtp.yml.example #{ node["inaturalist"]["install_directory"] }/config/smtp.yml" do
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/smtp.yml.example") }
  not_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/smtp.yml") }
end

execute "sudo -u #{ node["inaturalist"]["user"] } cp #{ node["inaturalist"]["install_directory"] }/config/sphinx.yml.example #{ node["inaturalist"]["install_directory"] }/config/sphinx.yml" do
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/sphinx.yml.example") }
  not_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/sphinx.yml") }
end

script "edit_config_yml" do
  interpreter "bash"
  user node["inaturalist"]["user"]
  cwd node["inaturalist"]["install_directory"]
  code <<-EOH
  sed -i 's/http:\\\/\\\/www\\\.yoursite\\\.com/http:\\\/\\\/localhost:3000/g' #{ node["inaturalist"]["install_directory"] }/config/config.yml
  sed -i 's/yourbucketname/staticdev\\\.inaturalist\\\.org/g' #{ node["inaturalist"]["install_directory"] }/config/config.yml
  EOH
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/config.yml") }
  not_if "grep staticdev #{ node["inaturalist"]["install_directory"] }/config/config.yml"
  action :nothing
end

script "edit_database_yml_password" do
  interpreter "bash"
  user node["inaturalist"]["user"]
  cwd node["inaturalist"]["install_directory"]
  code <<-EOH
  sed -i 's/template_postgis/template_postgis\\\n  password: #{ node["inaturalist"]["db"]["password"] }/' #{ node["inaturalist"]["install_directory"] }/config/database.yml
  EOH
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/database.yml") }
  not_if { node["inaturalist"]["db"]["password"].nil? }
  not_if "grep #{ node["inaturalist"]["db"]["password"] } #{ node["inaturalist"]["install_directory"] }/config/database.yml"
  action :nothing
end

script "edit_database_yml" do
  interpreter "bash"
  user node["inaturalist"]["user"]
  cwd node["inaturalist"]["install_directory"]
  code <<-EOH
  sed -i 's/host: localhost/host: #{ node["inaturalist"]["db"]["host"] }/' #{ node["inaturalist"]["install_directory"] }/config/database.yml
  sed -i 's/username: you/username: #{ node["inaturalist"]["db"]["user"] }/' #{ node["inaturalist"]["install_directory"] }/config/database.yml
  EOH
  only_if { File.exists?("#{ node["inaturalist"]["install_directory"] }/config/database.yml") }
  not_if "grep #{ node["inaturalist"]["db"]["password"] } #{ node["inaturalist"]["install_directory"] }/config/database.yml"
  action :nothing
  notifies :run, "rvm_shell[create_databases]", :immediate
end

rvm_shell "create_databases" do
  ruby_string node["rvm"]["user_installs"].first["default_ruby"]
  user node["inaturalist"]["user"]
  cwd node["inaturalist"]["install_directory"]
  code <<-EOH
  rake db:setup
  rake db:setup RAILS_ENV=test
  EOH
  action :nothing
end
