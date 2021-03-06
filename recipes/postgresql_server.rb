#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: postgresql_server
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

node.default["postgresql"]["pg_hba"] = [ ]
node.run_state["all_nodes"].each do |server|
  node.default["postgresql"]["pg_hba"] << {
    "type" => "host",
    "db" => "all",
    "user" => node["inaturalist"]["db"]["user"],
    "addr" => server["ipaddress"] + "/24",
    "method" => "md5"
  }
end

node.default["inaturalist"]["db"]["host"] = node_data(node)["ipaddress"]
node.default["inaturalist"]["db"]["restore_host"] = node.default["inaturalist"]["db"]["host"]
node.default["postgresql"]["config"]["listen_addresses"] = node_data(node)["ipaddress"]

node.default["postgresql"]["config_pgtune"]["db_type"] = "web"
node.default["postgresql"]["config_pgtune"]["max_connections"] = 100

iptables_rule "firewall_b_postgresql_server"

include_recipe "inaturalist-cookbook::inaturalist_user"
include_recipe "postgresql::server"
include_recipe "postgresql::config_pgtune"

%w(postgis postgresql-9.3-postgis-2.1).each do |pkg|
  package pkg
end

script "initialize_postgis" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo -u postgres createdb template_postgis
  sudo -u postgres psql template_postgis -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis'"
  sudo -u postgres psql template_postgis < /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql
  sudo -u postgres psql template_postgis < /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql
  sudo -u postgres createdb -T template_postgis inaturalist_production
  sudo -u postgres psql -c "CREATE USER #{ node["inaturalist"]["db"]["user"] } WITH SUPERUSER PASSWORD '#{ node["inaturalist"]["db"]["password"] }';"
  EOH
  not_if "sudo -u postgres psql -l | grep template_postgis"
end
