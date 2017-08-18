#
# Cookbook:: php56_apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Install php packages
include_recipe 'php56_apache::install_packages'

# Install mysql client for running cli tasks that uses mysql commands
include_recipe 'php56_apache::mysql_client'

# Remove server tokens from api responses
include_recipe 'php56_apache::disable_signatures'

# Install composer
include_recipe 'php56_apache::install_composer'

# Set apache configurations
include_recipe 'php56_apache::apache_conf'

# Set apache configurations for ssl
include_recipe 'php56_apache::ssl'
