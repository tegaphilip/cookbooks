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
end
