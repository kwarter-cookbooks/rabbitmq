#
# Cookbook Name:: rabbitmq
# Recipe:: exchange_management
#
# Copyright 2013,  Kwarter, Inc.
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

include_recipe "rabbitmq::default"


enabled_exchanges = node['rabbitmq']['enabled_exchanges']

Chef::Log.info( enabled_exchanges.each)

enabled_exchanges.each do |exchange|
  rabbitmq_exchange exchange['name'] do
    action :add
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end

disabled_exchanges = node['rabbitmq']['disabled_exchanges']

disabled_exchanges.each do |exchange|
  rabbitmq_exchange exchange do
    action :delete
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end
