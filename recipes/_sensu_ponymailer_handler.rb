#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: _sensu_ponymailer_handler
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

sensu_gem "pony"

cookbook_file "/etc/sensu/handlers/ponymailer.rb" do
  source "handlers/ponymailer.rb"
  mode 0755
end

sensu_handler "ponymailer" do
  type "pipe"
  command "ponymailer.rb"
  severities [ "ok", "critical","warning" ]
end

sensu_snippet "ponymailer" do
  content(
    :authenticate => false,
    :tls => false,
    :port => 25,
    :fromname => node["monitor"]["from_name"],
    :hostname => node["monitor"]["from_host"],
    :from => node["monitor"]["from_email"],
    :recipients => node["monitor"]["email_recipients"])
end
