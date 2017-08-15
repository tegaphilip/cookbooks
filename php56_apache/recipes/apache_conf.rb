#
# Cookbook:: php56_apache
# Recipe:: apache_conf
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

Chef::Log::info('Hey tega I got here')

file "#{node['apache2_dir']}/sites-available/0001-default.conf" do
  action :create
end

template "#{node['apache2_dir']}/sites-available/0001-default.conf" do
  source 'default.conf.erb'
end
