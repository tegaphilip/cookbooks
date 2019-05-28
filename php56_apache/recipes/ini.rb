#
# Cookbook:: php56_apache
# Recipe:: disable_signatures
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Add the site configuration.

ini_file = node[:php_ini]
if File.exist?(ini_file)
	file = File.open(ini_file, "rb")
	contents = file.read
	contents = contents.gsub('post_max_size', ';')
	contents = contents.gsub('upload_max_filesize', ';')
	contents = contents.gsub('max_execution_time', ';')
	contents = contents.gsub('max_input_time', ';')

	contents = contents + "\n" + 'max_execution_time = 300'
	contents = contents + "\n" + 'max_input_time = 300'
	contents = contents + "\n" + 'post_max_size = 32M'
	contents = contents + "\n" + 'upload_max_filesize = 32M'

	file ini_file do
	  content contents
	end

end
