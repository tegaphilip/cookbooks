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

# Update php ini file
include_recipe 'php56_apache::ini'

# Install composer
include_recipe 'php56_apache::install_composer'

# Set apache configurations
include_recipe 'php56_apache::apache_conf'

# Set apache configurations for ssl
include_recipe 'php56_apache::ssl'

# Install wkhtmltopdf
include_recipe 'php56_apache::wkhtmltopdf'

# Install wkhtmltopdf
include_recipe 'php56_apache::locales'
