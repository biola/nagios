#
# Cookbook Name:: nagios
# Recipe:: client_windows_uninstall
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

if node['platform'] == "windows" then
  arch = node['kernel']['machine'] == "x86_64" ? "x64" : "Win32"

  # Stop the nscp service before uninstallation
  service "nscp" do
    action [ :stop, :disable ]
  end

  # Uninstall NSClient++ using Powershell (since the UninstallString in the registry is not valid for this package)
  powershell_script "uninstall nsclient" do
    code <<-EOH
    $app = Get-WmiObject -Class Win32_Product -Filter "Name = 'NSClient++ (#{arch})'"
    $app.Uninstall()
    EOH
  end
end