#
# Cookbook:: php56_apache
# Recipe:: ssl
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

sites_available_path = node['apache2']['sites_available_path']
sites_enabled_path = node['apache2']['sites_enabled_path']
mod_enabled_path = node['apache2']['mod_enable_path']
ssl_conf = sites_available_path + '/default-ssl.conf'
cert_file = node['apache2_dir'] + '/ssl/ssl-bundle.crt'
cert_key_file = node['apache2_dir'] + '/ssl/hocaboo.com.key'


directory "#{node['apache2_dir']}/ssl" do
  recursive true
end

file "#{cert_file}" do
  action :create
end

file "#{cert_key_file}" do
  action :create
end

s3_file "#{cert_key_file}" do
  Chef::Log.info("Downloading S3 Key File")
	remote_path "#{node['hocaboo']['server']['cert_key_file']}"
	bucket "#{node['hocaboo']['server']['cert_bucket']}"
	aws_access_key_id node['hocaboo']['environment_variables']['AWS_ACCESS_KEY_ID']
	aws_secret_access_key node['hocaboo']['environment_variables']['AWS_SECRET_ACCESS_KEY']
end

s3_file "#{cert_file}" do
  Chef::Log.info("Downloading S3 Cert File")
	remote_path "#{node['hocaboo']['server']['cert_file']}"
	bucket "#{node['hocaboo']['server']['cert_bucket']}"
	aws_access_key_id node['hocaboo']['environment_variables']['AWS_ACCESS_KEY_ID']
	aws_secret_access_key node['hocaboo']['environment_variables']['AWS_SECRET_ACCESS_KEY']
end


# Create the configuration file for ssl if it does not exist
file "#{ssl_conf}" do
  action :create
end

# Modify the content of the ssl configuration file using a template
template "#{ssl_conf}" do
  source 'ssl.conf.erb'
end

# Restart apache if the ssl configuration file changes
service 'apache2' do
  subscribes :restart, "file[#{ssl_conf}]", :immediately
end

# Enable ssl if not already enabled and restart apache
execute 'enable_ssl' do
  command "a2enmod ssl"
  action :run
  notifies :restart, 'service[apache2]', :immediately
  not_if { ::File.exist?("#{mod_enabled_path}/ssl.conf") }
end

# Set symbolic link if it does not already exist
execute 'set_ssl_symbolic_link' do
  # command "ln -s #{ssl_conf} #{sites_enabled_path}/000-default-ssl.conf"
  command "ln -s #{ssl_conf} #{sites_enabled_path}/default-ssl.conf"
  action :run
  notifies :restart, 'service[apache2]', :immediately
  # not_if { ::File.exist?("#{sites_enabled_path}/000-default-ssl.conf") }
  not_if { ::File.exist?("#{sites_enabled_path}/default-ssl.conf") }
end
