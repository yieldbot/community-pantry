#
# Cookbook Name::       ganglia
# Description::         Ganglia server -- contact point for all ganglia_agents
# Recipe::              server
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Chris Howe - Infochimps, Inc
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

include_recipe 'ganglia'
include_recipe 'runit'
include_recipe 'volumes'

daemon_user('ganglia.server')

package "ganglia-webfrontend"
package "gmetad"
package "ganglia-monitor"

#
# Create service
#

standard_dirs('ganglia.server') do
  directories [:home_dir, :log_dir, :conf_dir, :pid_dir, :data_dir]
end

if node[:ganglia][:data_dir] != "#{node[:ganglia][:home_dir]}/rrds"
  directory "#{node[:ganglia][:home_dir]}/rrds" do
    recursive true
    action :delete
  end
  link "#{node[:ganglia][:home_dir]}/rrds" do
    to node[:ganglia][:data_dir]
  end
end

kill_old_service('gmetad')
kill_old_service('ganglia-monitor'){ pattern 'gmond' }

#
# Conf file -- auto-discovers ganglia agents
#

monitor_groups = Hash.new{|h,k| h[k] = [] }
monitor_groups[node[:cluster_name]] = [node[:ipaddress]]

template "#{node[:ganglia][:conf_dir]}/gmetad.conf" do
  source        "gmetad.conf.erb"
  backup        false
  owner         "ganglia"
  group         "ganglia"
  mode          "0644"
  notifies  :restart, "service[ganglia_server]", :delayed if startable?(node[:ganglia][:server])
  variables :monitor_groups => monitor_groups
end

runit_service "ganglia_server" do
  run_state     node[:ganglia][:server][:run_state]
  options       Mash.new(node[:ganglia].to_hash).merge(node[:ganglia][:server].to_hash)
end

announce(:ganglia, :server, {
  :daemons => {
    :gmetad => { :name => 'gmetad', :user => node[:ganglia][:user] },
  },
})
