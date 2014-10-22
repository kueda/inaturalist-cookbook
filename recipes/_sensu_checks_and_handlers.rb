#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: _sensu_checks_and_handlers
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

include_recipe "inaturalist-cookbook::_sensu_ponymailer_handler"
include_recipe "inaturalist-cookbook::_sensu_slack_handler"
include_recipe "inaturalist-cookbook::_sensu_remediation_handler"
include_recipe "inaturalist-cookbook::_sensu_graphite_handler"
include_recipe "inaturalist-cookbook::_sensu_check_disk"
include_recipe "inaturalist-cookbook::_sensu_check_load"
include_recipe "inaturalist-cookbook::_sensu_check_ram"
include_recipe "inaturalist-cookbook::_sensu_check_swap"
include_recipe "inaturalist-cookbook::_sensu_check_chef_nodes"
include_recipe "inaturalist-cookbook::_sensu_metrics_vmstat"
