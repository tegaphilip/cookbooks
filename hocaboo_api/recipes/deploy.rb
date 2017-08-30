#
# Cookbook:: hocaboo_api
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

env_variables = ''
node['hocaboo']['database'].each do |key, value|
    env_variables = env_variables + 'DB_' + key.to_s.upcase + '=' + value.to_s + "\n"
end

node['hocaboo']['environment_variables'].each do |key, value|
    env_variables = env_variables + key.to_s.upcase + '=' + value.to_s + "\n"
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

envs = node['hocaboo']['environment_variables']
slack_token = envs['SLACK_TOKEN']
channel = 'downtime'

message = '{{MESSAGE}}'
slack_command = "curl -d 'token=" + slack_token + "&channel=" + channel + "&text=" +
                 message +"&link_names=true&username=Deployer'" +
                 " -X POST https://slack.com/api/chat.postMessage"

def post_to_slack(command_string)
  execute "message" do
    command command_string
  end
end

deployment_message = "*Deployment to instance `" + node['hostname'] +
"` of " + envs['CI_ENV'] + " API Server"

starting = deployment_message + " starting*"
my_command = slack_command.sub '{{MESSAGE}}', starting
post_to_slack(my_command)

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
      content env_variables
    end

    directory "#{current_release}/tmp" do
      mode '0777'
      owner "#{node[:deploy][:user]}"
    end

    # send terminate signal to currently running php processes
    # if deployment is on worker instance
    if node['hostname'].include? 'worker'
      Chef::Log::info('Killing PHP jobs on worker instances')
      execute 'kill_php' do
        command "kill $(ps aux | grep '[^]]/usr/bin/php' | awk '{print $2}')"
      end
    end

  end
end

ending = deployment_message + " ending*"
my_command = slack_command.sub '{{MESSAGE}}', ending
post_to_slack(my_command)
