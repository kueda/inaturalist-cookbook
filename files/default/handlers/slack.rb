#!/usr/bin/env ruby

# Copyright 2014 Dan Shultz and contributors.
#   (with modifications Oct, 2014 by Patrick Leary
#    to use Slack's chat.postMessage API)
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.
#
# In order to use this plugin, you must first configure an incoming webhook
# integration in slack. You can create the required webhook by visiting
# https://{your team}.slack.com/services/new/incoming-webhook
#
# After you configure your webhook, you'll need to token from the integration.
# The default channel and bot name entered can be overridden by this handlers
# configuration.
#
# Minimum configuration required is the 'token' and 'team_name'

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'json'
require 'uri'
require 'net/http'

class Slack < Sensu::Handler

  def slack_token
    get_setting('token')
  end

  def slack_channel
    get_setting('channel')
  end

  def slack_team_name
    get_setting('team_name')
  end

  def slack_bot_name
    get_setting('bot_name')
  end

  def incident_key
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def get_setting(name)
    settings["slack"][name]
  end

  def handle
    description = @event['notification'] || build_description
    post_data("*#{incident_key}*: #{description}")
  end

  def build_description
    @event['check']['output']
  end

  def post_data(notice)
    uri = slack_uri(slack_token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
    req.set_form_data( payload(notice) )

    response = http.request(req)
    verify_response(response)
  end

  def verify_response(response)
    case response
    when Net::HTTPSuccess
      true
    else
      raise response.error!
    end
  end

  def payload(notice)
    {
      :icon_url => 'http://sensuapp.org/img/sensu_logo_large-c92d73db.png',
      :channel => slack_channel,
      :username => slack_bot_name,
      :text => notice
    }
  end

  def slack_uri(token)
    url = "https://slack.com/api/chat.postMessage?token=#{token}"
    URI(url)
  end

end
