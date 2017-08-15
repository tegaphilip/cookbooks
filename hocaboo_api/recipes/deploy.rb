data = ''
node['hocaboo']['database'].each do |key, value|
    data = data + 'DB_' + key.to_s.upcase + '=' + value.to_s + "\n"
end

node['hocaboo']['environment_variables'].each do |key, value|
    data = data + key.to_s.upcase + '=' + value.to_s + "\n"
end

deploy 'App' do
  user node[:deploy][:user]
  repository 'git@gitlab.com:hocaboo/api.git'
  revision 'hocaboolive'
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
