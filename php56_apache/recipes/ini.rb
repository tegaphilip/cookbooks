#
# Cookbook:: php56_apache
# Recipe:: disable_signatures
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

ini_file= node[:php_ini]
if File.exist?(ini_file)
	execute 'Increase post max size' do
		command "echo 'post_max_size = 20M' >> #{ini_file}"
		action :run
		not_if "grep '^post_max_size = 20M$' #{ini_file}"
	end
end
