#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: _sensu_graphite_handler
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

if node[:monitor] && node[:monitor][:graphite_address]
  sensu_handler "graphite" do
    type "tcp"
    mutator "only_check_output"
    socket "host" => node[:monitor][:graphite_address], "port" => node[:monitor][:graphite_port].to_i
  end
end
