#
# Cookbook:: php56_apache
# Recipe:: locales
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

#update apt-cache
apt_update 'Update the apt-cache' do
	action :update
end

Chef::Log::info("Installing locales")
package "locales" do
end

locales_commands = "sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && " +
"sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && " +
"sed -i -e 's/# de_AT.UTF-8 UTF-8/de_AT.UTF-8 UTF-8/' /etc/locale.gen && " +
"sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && " +
"echo 'LANG=en_US.UTF-8'>/etc/default/locale && " +
"dpkg-reconfigure --frontend=noninteractive locales"


Chef::Log::info("Updating locales")
execute 'Update locales' do
  command locales_commands
end
