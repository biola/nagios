#
# Cookbook Name:: nagios
# Recipe:: datadog_check
#
# Copyright 2013, Biola University 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Add the dd-agent user to the www-data group
if `id -u dd-agent > /dev/null 2>&1`
  group "www-data" do
    action :modify
    members "dd-agent"
    append true
  end
end

# Create the configuration file
if File.directory?("/etc/dd-agent/conf.d")
  template "/etc/dd-agent/conf.d/nagios.yaml" do
    source "datadog_check.yaml.erb"
    notifies :restart, resources(:service => "datadog-agent")
  end
end

# Create the agent check
if File.directory?("/etc/dd-agent/checks.d")
  template "/etc/dd-agent/checks.d/nagios.py" do
    source "datadog_check.py.erb"
    notifies :restart, resources(:service => "datadog-agent")
  end
end

# Restart the service only if configuration has been modified
service "datadog-agent" do
  action [ :nothing ]
end