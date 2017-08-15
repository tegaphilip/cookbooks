#
# Cookbook:: php56_apache
# Recipe:: apache_conf
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

default_conf = node['apache2']['sites_available_path'] + '/000-default.conf'
mod_enabled_path = node['apache2']['mod_enable_path']

file "#{default_conf}" do
  action :create
end

template "#{default_conf}" do
  source 'default.conf.erb'
end

service 'apache2' do
  # supports { :restart => true, :status => true }
  subscribes :restart, "template[#{default_conf}]", :immediately
end

execute 'enable_apache_rewrite_engine' do
  command 'a2enmod rewrite'
  action :run
  notifies :restart, 'service[apache2]', :immediately
  not_if { ::File.exist?("#{mod_enabled_path}/rewrite.load") }
end
