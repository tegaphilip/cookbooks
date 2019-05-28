#
# Cookbook:: php56_apache
# Recipe:: install_packages
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

apt_repository 'php56_repo' do
  uri 'ppa:ondrej/php'
  # components ['main', 'stable']
	action :add
end

apt_update 'Update the apt-cache' do
	#frequency 86_400
	#action :periodic
	action :update
end

#Install apache
package value_for_platform_family(:rhel => 'httpd', :debian => 'apache2') do
	Chef::Log.info("Installing apache2")
	action :install
end

packages = [
	'php5.6',
	'php5.6-mysql',
	'php5.6-gettext',
	'php5.6-mbstring',
  'php5.6-mcrypt',
	# 'php5.6-xdebug',
  # 'php-xdebug',
	'libapache2-mod-php5.6',
	'php5.6-curl',
	'php5.6-zip',
	'php5.6-dom',
	'php5.6-gd',
  'php5.6-bcmath',
  'php5.6-sockets'
]

packages.each { |package_name|
	Chef::Log.info("Installing package : #{package_name}")
	package "#{package_name}" do
		action 'install'
	end
}

# Restart apache
service 'apache2' do
  action :restart
end
# Remove the added apt-cache repository
# apt_repository 'php56_repo' do
#   uri 'ppa:ondrej/php'
# 	action :remove
# end
