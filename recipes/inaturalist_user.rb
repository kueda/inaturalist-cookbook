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

load_secure_data_bags([ :ssh, :postgresql ])

# Add SSH keys
if secure = node.run_state["inaturalist"]["secure"]["ssh"]
  directory "/home/inaturalist/.ssh" do
    owner "inaturalist"
    group "inaturalist"
    action :create
    mode "0700"
  end

  file "/home/inaturalist/.ssh/id_rsa" do
    content secure["id_rsa"]
    owner "inaturalist"
    group "inaturalist"
    mode "0600"
  end

  file "/home/inaturalist/.ssh/id_rsa.pub" do
    content secure["id_rsa.pub"]
    owner "inaturalist"
    group "inaturalist"
    mode "0600"
  end
end

# Add PostgreSQL SSH keys
if secure = node.run_state["inaturalist"]["secure"]["postgresql"]
  directory "/home/inaturalist/.postgresql" do
    owner "inaturalist"
    group "inaturalist"
    action :create
    mode "0700"
  end

  file "/home/inaturalist/.postgresql/postgresql.crt" do
    content secure["postgresql.crt"]
    owner "inaturalist"
    group "inaturalist"
    mode "0600"
  end

  file "/home/inaturalist/.postgresql/postgresql.csr" do
    content secure["postgresql.csr"]
    owner "inaturalist"
    group "inaturalist"
    mode "0600"
  end

  file "/home/inaturalist/.postgresql/postgresql.key" do
    content secure["postgresql.key"]
    owner "inaturalist"
    group "inaturalist"
    mode "0600"
  end

  file "/home/inaturalist/.postgresql/root.crt" do
    content secure["root.crt"]
    owner "inaturalist"
    group "inaturalist"
    mode "0600"
  end
end
