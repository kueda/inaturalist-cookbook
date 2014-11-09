#
# Cookbook Name:: inaturalist-cookbook
# Attributes:: windshaft
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

default["windshaft"] ||= { }
default["windshaft"]["git_repo"] = "https://github.com/inaturalist/Windshaft-inaturalist.git"
default["windshaft"]["git_reference"] = "master"
default["windshaft"]["user"] = "inaturalist"
default["windshaft"]["group"] = "inaturalist"
default["windshaft"]["install_directory"] = "/home/inaturalist/windshaft"

default["windshaft"]["db"] = { }
default["windshaft"]["db"]["database"] = "inaturalist"
default["windshaft"]["db"]["user"] = "postgres"
default["windshaft"]["db"]["password"] = nil
default["windshaft"]["db"]["host"] = "127.0.0.1"
default["windshaft"]["db"]["port"] = 5432
default["windshaft"]["db"]["debug"] = false

default["windshaft"]["redis"] = { }
default["windshaft"]["redis"]["host"] = "127.0.0.1"
default["windshaft"]["redis"]["port"] = 6379
