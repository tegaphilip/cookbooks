#
# Cookbook:: hocaboo_api
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

data = ''
node['hocaboo']['database'].each do |key, value|
    data = data + 'DB_' + key.to_s.upcase + '=' + value.to_s + "\n"
end

node['hocaboo']['environment_variables'].each do |key, value|
    data = data + key.to_s.upcase + '=' + value.to_s + "\n"
end

git_url = 'git@gitlab.com:hocaboo/api.git'
revision = node['hocaboo']['app']['revision']


directory '/var/www/html/hocaboo-api' do
  recursive true
end

# For some reason, this command is needed to authenticate gitlab as a known host
known_hosts = "/home/#{node[:deploy][:user]}/.ssh/known_hosts"
execute 'add_gitlab_as_known_host' do
  user 'root'
  command "ssh-keyscan gitlab.com >> #{known_hosts} 2>/dev/null"
  not_if "grep '^gitlab.com ' #{known_hosts} "
end
# bash 'allow_remote_host' do
#   user node[:deploy][:user]
#   cwd '/var/www/html/hocaboo-api'
#   code <<-EOH
#     #!/usr/bin/expect
#     spawn "git ls-remote '#{git_url}' '#{revision}*'";
#     expect 'Are you sure you want to continue connecting (yes/no)? ';
#     send 'yes\r';
#     EOH
# end

# script 'allow_remote_host' do
#   user node[:deploy][:user]
#   cwd '/var/www/html/hocaboo-api'
#   interpreter "/usr/bin/expect"
#   code <<-EOH
#     set timeout 360
#     spawn "git ls-remote '#{git_url}' '#{revision}*'"
#     expect "Are you sure you want to continue connecting (yes/no)? " { send "yes\r" }
#     EOH
# end

deploy 'App' do
  user node[:deploy][:user]
  repository "#{git_url}"
  revision revision
  keep_releases 5
  migrate false
  ignore_failure false
  symlink_before_migrate ({})
  deploy_to '/var/www/html/hocaboo-api'
  action :deploy

  before_restart do
    current_release = release_path

    execute 'run_composer' do
      cwd current_release
      command 'composer install'
      action :run
    end

    file "#{current_release}/v1.0/application/env/.env" do
      content data
    end
  end
end
