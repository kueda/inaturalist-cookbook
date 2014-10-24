#
# Cookbook Name:: inaturalist-cookbook
# Attributes:: sensu
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

default["monitor"] ||= { }
default["monitor"]["email_recipients"] = [ ]
default["monitor"]["from_email"] = "monitor@localhost"
default["monitor"]["from_name"] = "Sensu Monitor"
default["monitor"]["from_host"] = "localhost"
default["monitor"]["additional_client_attributes"] ||= {}
default["monitor"]["additional_client_attributes"]["keepalive"] ||= {}
default["monitor"]["additional_client_attributes"]["keepalive"]["handlers"] = [ "ponymailer" ]

default["uchiwa"] ||= { }
default["uchiwa"]["settings"] ||= { }
default["uchiwa"]["settings"]["user"] = "sensu"
default["uchiwa"]["settings"]["pass"] = "password"

default["postfix"] ||= { }
default["postfix"]["mydomain"] = "localhost"
default["postfix"]["myorigin"] = "localhost"
default["postfix"]["smtp_use_tls"] = "no"
default["postfix"]["smtpd_use_tls"] = "no"
