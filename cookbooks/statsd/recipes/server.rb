#
# Cookbook Name::       statsd
# Description::         Server
# Recipe::              server
# Author::              Nathaniel Eliot - Infochimps, Inc
#
# Copyright 2011, Nathaniel Eliot - Infochimps, Inc
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

include_recipe 'runit'
include_recipe 'silverware'
include_recipe 'statsd'
include_recipe 'graphite'

daemon_user(:statsd)

standard_dirs('statsd') do
  directories   :conf_dir, :log_dir, :pid_dir
end

git node[:statsd][:home_dir] do
  repository    node[:statsd][:git_repo]
  reference     "master"
  action        :checkout
  notifies      :restart, "service[statsd]", :delayed if startable?(node[:statsd])
end

runit_service "statsd" do
  run_state     node[:statsd][:run_state]
  options       node[:statsd]
end

announce(:statsd, :server,
  :port => node[:statsd][:port])

# FIXME: this interface could use some help
graphite_host = discover(:graphite, :carbon).private_ip rescue '127.0.0.1'

template "#{node[:statsd][:conf_dir]}/baseConfig.js" do
  source        "baseConfig.js.erb"
  mode          "0755"
  variables     :statsd => node[:statsd], :graphite_host => graphite_host
  notifies      :restart, "service[statsd]", :delayed if startable?(node[:statsd])
end
