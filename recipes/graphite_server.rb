#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: graphite_server
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

include_recipe "runit"
include_recipe "graphite::carbon"
include_recipe "graphite::_web_packages"
include_recipe "statsd"

# We want to use Apache
include_recipe "apache2"
package "apache2-utils"
package "libapache2-mod-wsgi"

apache_module "wsgi"

directory "#{ node['apache']['dir'] }/run" do
  owner node["apache"]["user"]
  group node["apache"]["group"]
end

template "#{ node['apache']['dir'] }/sites-available/graphite.conf" do
  source "graphite-vhost.conf.erb"
  notifies :reload, "service[apache2]"
end

apache_site "graphite"

file "#{ node['graphite']['storage_dir'] }/log/webapp/info.log" do
  owner node["apache"]["user"]
  group node["graphite"]["group"]
end

file "#{ node['graphite']['storage_dir'] }/log/webapp/exception.log" do
  owner node["apache"]["user"]
  group node["graphite"]["group"]
end

file "#{ node['graphite']['storage_dir'] }/log/webapp/error.log" do
  owner node["apache"]["user"]
  group node["graphite"]["group"]
end

execute "sudo -u root cp #{ node['graphite']['base_dir'] }/conf/graphite.wsgi.example #{ node['graphite']['base_dir'] }/conf/graphite.wsgi" do
  only_if { File.exists?("#{ node['graphite']['base_dir'] }/conf/graphite.wsgi.example") }
  not_if { File.exists?("#{ node['graphite']['base_dir'] }/conf/graphite.wsgi") }
end



# from https://github.com/hw-cookbooks/graphite/blob/master/example/graphite_example/recipes/single_node.rb

graphite_carbon_cache "default" do
  config ({
            enable_logrotation: true,
            user: "graphite",
            max_cache_size: "inf",
            max_updates_per_second: 500,
            max_creates_per_minute: 50,
            line_receiver_interface: "0.0.0.0",
            line_receiver_port: 2003,
            udp_receiver_port: 2003,
            pickle_receiver_port: 2004,
            enable_udp_listener: true,
            cache_query_port: "7002",
            cache_write_strategy: "sorted",
            use_flow_control: true,
            log_updates: false,
            log_cache_hits: false,
            whisper_autoflush: false
          })
end

graphite_storage_schema "carbon" do
  config ({
            pattern: "^carbon\.",
            retentions: "60:90d"
          })
end

graphite_storage_schema "default_1min_for_1day" do
  config ({
            pattern: ".*",
            retentions: "60s:1d"
          })
end

graphite_service "cache"

base_dir = "#{node['graphite']['base_dir']}"

graphite_web_config "#{base_dir}/webapp/graphite/local_settings.py" do
  config({
           secret_key: "a_very_secret_key_jeah!",
           time_zone: "America/Chicago",
           conf_dir: "#{base_dir}/conf",
           storage_dir: "#{base_dir}/storage",
           databases: {
             default: {
               # keys need to be upcase here
               NAME: "#{base_dir}/storage/graphite.db",
               ENGINE: "django.db.backends.sqlite3",
               USER: nil,
               PASSWORD: nil,
               HOST: nil,
               PORT: nil
             }
           }
         })
  notifies :restart, "service[graphite-web]", :delayed
end

directory "#{base_dir}/storage/log/webapp" do
  owner node["graphite"]["user"]
  group node["graphite"]["group"]
  recursive true
end

execute "python manage.py syncdb --noinput" do
  user node["graphite"]["user"]
  group node["graphite"]["group"]
  cwd "#{base_dir}/webapp/graphite"
  creates "#{base_dir}/storage/graphite.db"
end

# creates an initial user, doesn't require the set_admin_password
# script. But srsly, how ugly is this? also, not idempotent could be
# crazy and wrap this as a graphite_user resource with a few
# improvements...
python "set admin password" do
  cwd "#{base_dir}/webapp/graphite"
  user node["graphite"]["user"]
  code <<-PYTHON
import os,sys
sys.path.append("#{base_dir}/webapp/graphite")
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
from django.contrib.auth.models import User

username = "#{node['graphite']['user']}"
password = "#{node['graphite']['password']}"

try:
    u = User.objects.create_user(username, password=password)
    u.save()
except Exception,err:
    print "could not create %s" % username
    print "died with error: %s" % str(err)
  PYTHON
  # could be idempotent just by reading for user from db, ignore
  # django models?
end

runit_service "graphite-web" do
  cookbook "graphite"
  default_logger true
end
