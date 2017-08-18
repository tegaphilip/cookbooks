#
# Cookbook:: initial_setup
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Install expect
package 'expect'

include_recipe 'initial_setup::grant_permissions'

include_recipe 'initial_setup::generate_ssh_keys'
