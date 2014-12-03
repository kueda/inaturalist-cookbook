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

default["inaturalist"] = {
  "site_url" => "http://#{ node["ipaddress"] }",
  "site_name" => "iNaturalist.org",
  "settings_site_name" => "iNaturalist",
  "site_name_short" => "iNat",
  "site_contact" => { },
  "logo_large" => "logo_inaturalist_large.png",
  "about_url" => "/pages/about",
  "help_url" => "/pages/help",
  "noreply_email" => "no-reply@yoursite.org",
  "admin_email" => "admin@yoursite.org",
  "help_email" => "help@yoursite.org",
  "info_email" => "info@yoursite.org",
  "memcached_host" => "127.0.0.1",
  "assets_host" => nil,
  "statsd_host" => nil,
  "sphinx" => {
    "host" => "127.0.0.1",
    "port" => 3312,
    "bin_path" => File.exists?("/usr/local/bin/searchd") ?
      "/usr/local/bin/" : "/usr/bin/"
  },
  "smtp" => {
    "user_name" => nil,
    "password" => nil,
    "domain" => "yoursite.org",
    "address" => "127.0.0.1",
    "port" => "25"
  },
  "airbrake" => {
    "api_key" => hex * 32
  },
  "amazon" => {
    "access_key_id" => hex * 16,
    "secret_access_key" => hex * 32
  },
  "bing" => {
    "key" => hex * 64
  },
  "facebook" => {
    "app_id" => hex * 12,
    "app_secret" => hex * 32,
    "admin_ids" => "[0]"
  },
  "flickr" => {
    "key" => hex * 32,
    "shared_secret" => hex * 12
  },
  "google" => {
    "client_id" => (hex * 12) + ".apps.googleusercontent.com",
    "secret" => hex * 24,
    "webmaster_verification" => hex * 64,
    "tracker_id" => "UA-000000-0",
    "maps_api_key" => hex * 64,
    "simple_key" => hex * 64
  },
  "rails" => {
    "secret" => char * 128,
    "rest_auth" => char  * 40,
    "session_key" => "_inat_session"
  },
  "soundcloud" => {
    "client_id" => hex * 32,
    "secret" => hex * 32
  },
  "twitter" => {
    "key" => char * 32,
    "secret" => char * 64,
    "username" => char * 12
  },
  "ubio" => {
    "key" => hex * 32
  },
  "yahoo" => {
    "app_id" => hex * 64
  }
}
