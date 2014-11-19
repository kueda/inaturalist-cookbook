#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: inaturalist_user
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

group "inaturalist" do
  system true
  action :create
end

user "inaturalist" do
  supports :manage_home => true
  group "inaturalist"
  home "/home/inaturalist"
  shell "/bin/bash"
  action :create
end

begin
  unless Chef::Config[:solo]
    postgresql = Chef::EncryptedDataBagItem.load("secure", "postgresql")

    directory "/home/inaturalist/.postgresql" do
      owner "inaturalist"
      group "inaturalist"
      action :create
    end

    file "/home/inaturalist/.postgresql/postgresql.crt" do
      content postgresql["postgresql_crt"]
      owner "inaturalist"
      group "inaturalist"
      mode "0600"
    end

    file "/home/inaturalist/.postgresql/postgresql.csr" do
      content postgresql["postgresql_csr"]
      owner "inaturalist"
      group "inaturalist"
      mode "0600"
    end

    file "/home/inaturalist/.postgresql/postgresql.key" do
      content postgresql["postgresql_key"]
      owner "inaturalist"
      group "inaturalist"
      mode "0600"
    end

    file "/home/inaturalist/.postgresql/root.crt" do
      content postgresql["root_crt"]
      owner "inaturalist"
      group "inaturalist"
      mode "0600"
    end
  end
rescue Net::HTTPServerException => e
  if e.response.code == "404"
    puts("INFO: The data bag item secure/postgresql does not exist")
  end
end
