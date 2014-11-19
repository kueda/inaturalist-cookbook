#
# Cookbook Name:: inaturalist-cookbook
# Attributes:: development
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

default["inaturalist"] = { }
default["inaturalist"]["git_repo"] = "https://github.com/inaturalist/inaturalist.git"
default["inaturalist"]["git_reference"] = "master"
default["inaturalist"]["user"] = "vagrant"
default["inaturalist"]["group"] = "vagrant"
default["inaturalist"]["install_directory"] = "/home/inaturalist/inaturalist"

default["inaturalist"]["db"] = { }
default["inaturalist"]["db"]["database"] = "inaturalist"
default["inaturalist"]["db"]["user"] = "postgres"
default["inaturalist"]["db"]["password"] = nil
default["inaturalist"]["db"]["host"] = "127.0.0.1"
default["inaturalist"]["db"]["port"] = 5432
default["inaturalist"]["db"]["debug"] = false

default_install = { }
default_install["user"] = default["inaturalist"]["user"]
default_install["rubies"] = [ "ruby-1.9.3" ]
default_install["default_ruby"] = "ruby-1.9.3@inaturalist"
default_install["vagrant"] = { }
default_install["vagrant"]["system_chef_solo"] = "/usr/bin/chef-solo"

default["rvm"] ||= { }
default["rvm"]["user_installs"] = [ default_install ]
