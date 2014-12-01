#
# Cookbook Name:: inaturalist-cookbook
# Library:: helpers
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

module Inaturalist
  module Helpers

    #
    # Perform a chef search, and return a hash of results with the format:
    #   [ { name: "", ipaddress: "", public_ipaddress: "", roles: [ ] }, ... ]
    # Results are sorted by :name to ensure consistent order
    #
    def custom_search_nodes(query)
      matching_nodes = [ ]
      unless Chef::Config[:solo]
        search(:node, query).each do |n|
          ipaddress =
            # get the private IP if available
            if n.has_key?("cloud")
              n["cloud"]["local_ipv4"]
            # TODO: this was needed for older Rackspace VMs. This isn't going to work everywhere
            elsif n[:network][:interfaces][:eth1] &&
              ips = n[:network][:interfaces][:eth1][:addresses].detect{ |k,v| v[:family] == "inet" }
              ips.first
            else
              # otherwise return the public / default IP
              n["ipaddress"]
            end
          matching_nodes << {
            name: n["hostname"],
            ipaddress: ipaddress,
            public_ipaddress: n["ipaddress"],
            roles: n["roles"]
          }
        end
      end
      matching_nodes.sort_by{ |n| n[:name] }
    end

    #
    # Load secure data bags
    #
    def load_secure_data_bags(data_bags)
      unless Chef::Config[:solo]
        data_bags.each do |bag|
          begin
            secure_data = Chef::EncryptedDataBagItem.load("secure", bag).to_hash
            if secure_data["type"] == "environment_based"
              if environment_data = secure_data[node.chef_environment]
                environment_data.each do |key, value|
                  node.default["inaturalist"][bag][key] = value
                end
              end
            else
              secure_data.each do |key, value|
                node.default["inaturalist"][bag][key] = value
              end
            end
          rescue Net::HTTPServerException => e
            if e.response.code == "404"
              puts("ERROR: unable to load encrypted data bag: #{ bag }")
            end
          end
        end
      end
    end

    # File activesupport/lib/active_support/core_ext/object/blank.rb, line 15
    # An object is blank if it's false, empty, or a whitespace string.
    # For example, '', '   ', +nil+, [], and {} are all blank.
    def blank?(obj)
      obj.respond_to?(:empty?) ? !!obj.empty? : !obj
    end

  end
end

Chef::Recipe.send(:include, ::Inaturalist::Helpers)
