#
# Cookbook Name:: inaturalist-cookbook
# Recipe:: _sensu_slack_handler
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

if node["monitor"]["slack"]
  cookbook_file "/etc/sensu/handlers/slack.rb" do
    source "sensu/handlers/slack.rb"
    mode 0755
  end

  sensu_handler "slack" do
    type "pipe"
    command "slack.rb"
    severities [ "ok", "critical","warning" ]
  end

  sensu_snippet "slack" do
    content(
      :token => node["monitor"]["slack"]["token"],
      :channel => node["monitor"]["slack"]["channel"],
      :team_name => node["monitor"]["slack"]["team_name"],
      :bot_name => node["monitor"]["slack"]["bot_name"]
    )
  end
end
