#
# Cookbook Name => => inaturalist-cookbook
# Attributes => => app_server
#
# Copyright 2014, iNaturalist
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http =>//www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

hex = "1"
char = "a"

default["inaturalist"] ||= { }
default["inaturalist"]["site_url"] = "http://#{ node["ipaddress"] }"
default["inaturalist"]["site_htpasswd"] = nil
default["inaturalist"]["site_name"] = "iNaturalist.org"
default["inaturalist"]["settings_site_name"] = "iNaturalist"
default["inaturalist"]["site_name_short"] = "iNat"
default["inaturalist"]["site_contact"] = { }
default["inaturalist"]["logo_large"] = "logo_inaturalist_large.png"
default["inaturalist"]["about_url"] = "/pages/about"
default["inaturalist"]["help_url"] = "/pages/help"
default["inaturalist"]["noreply_email"] = "no-reply@yoursite.org"
default["inaturalist"]["admin_email"] = "admin@yoursite.org"
default["inaturalist"]["help_email"] = "help@yoursite.org"
default["inaturalist"]["info_email"] = "info@yoursite.org"
default["inaturalist"]["memcached_host"] = "127.0.0.1"
default["inaturalist"]["assets_host"] = nil
default["inaturalist"]["statsd_host"] = nil
default["inaturalist"]["windshaft_url"] = "http://127.0.0.1:4000"


default["inaturalist"]["sphinx"] ||= { }
default["inaturalist"]["sphinx"]["host"] = "127.0.0.1"
default["inaturalist"]["sphinx"]["port"] = 3312
default["inaturalist"]["sphinx"]["bin_path"] =
  File.exists?("/usr/local/bin/searchd") ? "/usr/local/bin/" : "/usr/bin/"

default["inaturalist"]["smtp"] ||= { }
default["inaturalist"]["smtp"]["user_name"] = nil
default["inaturalist"]["smtp"]["password"] = nil
default["inaturalist"]["smtp"]["domain"] = "yoursite.org"
default["inaturalist"]["smtp"]["address"] = node["ipaddress"]
default["inaturalist"]["smtp"]["port"] = "25"

default["inaturalist"]["airbrake"] ||= { }
default["inaturalist"]["airbrake"]["api_key"] = hex * 32

default["inaturalist"]["amazon"] ||= { }
default["inaturalist"]["amazon"]["access_key_id"] = hex * 16
default["inaturalist"]["amazon"]["secret_access_key"] = hex * 32

default["inaturalist"]["bing"] ||= { }
default["inaturalist"]["bing"]["key"] = hex * 64

default["inaturalist"]["facebook"] ||= { }
default["inaturalist"]["facebook"]["app_id"] = hex * 12
default["inaturalist"]["facebook"]["app_secret"] = hex * 32
default["inaturalist"]["facebook"]["admin_ids"] = "[0]"

default["inaturalist"]["flickr"] ||= { }
default["inaturalist"]["flickr"]["key"] = hex * 32
default["inaturalist"]["flickr"]["shared_secret"] = hex * 12

default["inaturalist"]["google"] ||= { }
default["inaturalist"]["google"]["client_id"] = (hex * 12) + ".apps.googleusercontent.com"
default["inaturalist"]["google"]["secret"] = hex * 24
default["inaturalist"]["google"]["webmaster_verification"] = hex * 64
default["inaturalist"]["google"]["tracker_id"] = "UA-000000-0"
default["inaturalist"]["google"]["maps_api_key"] = hex * 64
default["inaturalist"]["google"]["simple_key"] = hex * 64

default["inaturalist"]["rails"] ||= { }
default["inaturalist"]["rails"]["secret"] = char * 128
default["inaturalist"]["rails"]["rest_auth"] = char * 40
default["inaturalist"]["rails"]["session_key"] = "_inat_session"

default["inaturalist"]["soundcloud"] ||= { }
default["inaturalist"]["soundcloud"]["client_id"] = hex * 32
default["inaturalist"]["soundcloud"]["secret"] = hex * 32

default["inaturalist"]["twitter"] ||= { }
default["inaturalist"]["twitter"]["key"] = char * 32
default["inaturalist"]["twitter"]["secret"] = char * 64
default["inaturalist"]["twitter"]["username"] = char * 12

default["inaturalist"]["ubio"] ||= { }
default["inaturalist"]["ubio"]["key"] = hex * 32

default["inaturalist"]["yahoo"] ||= { }
default["inaturalist"]["yahoo"]["app_id"] = hex * 64
