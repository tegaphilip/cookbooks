#
# Cookbook:: php56_apache
# Recipe:: wkhtmltopdf
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

username = node[:deploy][:user]

Chef::Log::info("Got to installing dependencies")
execute 'Install dependecies' do
  command 'apt-get update && apt-get install -y curl libxrender1 libfontconfig libxtst6 xz-utils'
  action :run
end

Chef::Log::info("Got to downloading wkhtmltopdf")
execute 'Download wkhtmltopdf' do
  command 'curl "https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz" -L -o "wkhtmltopdf.tar.xz"'
  action :run
end

Chef::Log::info("Got to installing wkhtmltopdf")
execute 'Install wkhtmltopdf' do
  command 'tar Jxvf wkhtmltopdf.tar.xz && mv wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf'
end

#update fonts
apt_update 'Update the apt-cache' do
	action :update
end


Chef::Log::info("Installing fontconfig")
package 'fontconfig' do
	action 'install'
end

# execute "accept mscorefonts license" do
#   user "root"
#   command "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"
#   action :run
# end
#
# Chef::Log::info("Installing fonts")
# packages = [
# 	'ttf-mscorefonts-installer',
# 	'fontconfig'
# ]
#
# packages.each { |package_name|
# 	Chef::Log.info("Installing package : #{package_name}")
# 	package "#{package_name}" do
# 		action 'install'
# 	end
# }
#
# Chef::Log::info("Refreshing font cache")
# execute 'Refresh font cache' do
#   command 'fc-cache -f -v'
# end
