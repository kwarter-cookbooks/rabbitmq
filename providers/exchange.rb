#
# Cookbook Name:: rabbitmq
# Provider:: exchange
#
# Copyright 20113 Kwarter, Inc.
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

def exchange_exists?(name)
  cmd = Mixlib::ShellOut.new("rabbitmqctl list_exchanges |grep '#{name}\\b'")
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :add do
  unless exchange_exists?(new_resource.exchange)
    execute "rabbitmqctl add_exchange #{new_resource.exchange}" do
      Chef::Log.info "Adding RabbitMQ exchange '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  if exchange_exists?(new_resource.exchange)
    execute "rabbitmqctl delete_exchange #{new_resource.exchange}" do
      Chef::Log.info "Deleting RabbitMQ exchange '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end
