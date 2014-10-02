#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: database
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

include_recipe "postgresql::server"

%w(postgis postgresql-9.3-postgis-2.1).each do |pkg|
  package pkg
end

script "initialize_postgis" do
  interpreter "bash"
  user "vagrant"
  cwd "/home/vagrant"
  code <<-EOH
  sudo -u postgres createdb template_postgis
  sudo -u postgres psql template_postgis -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis'"
  sudo -u postgres psql template_postgis < /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql
  sudo -u postgres psql template_postgis < /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql
  EOH
  not_if "sudo -u postgres psql -l | grep template_postgis"
end

script "import_production_dump" do
  interpreter "bash"
  user "vagrant"
  cwd "/home/vagrant"
  code <<-EOH
  sudo -u postgres createdb -T template_postgis inaturalist_production
  sudo perl /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis_restore.pl /vagrant/inaturalist_production.csql | sudo -u postgres psql inaturalist_production
  EOH
  only_if "ls /vagrant | grep inaturalist_production\.csql"
  not_if "sudo -u postgres psql -l | grep inaturalist_production"
end
