#
# Cookbook Name:: inaturalist-cookbook
# Attributes:: windshaft_load_balancer
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

default["varnish"] ||= { }
default["varnish"]["listen_port"] = 80
default["varnish"]["vcl_cookbook"] = "inaturalist-cookbook"
default["varnish"]["vcl_source"] = "windshaft_default.vcl.erb"
