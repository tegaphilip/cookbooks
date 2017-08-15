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

  # restart do
  #   current_release = release_path
  #   file "#{release_path}/tmp/restart.txt" do
  #     mode '0755'
  #   end
  # end
  before_restart do
    current_release = release_path
    execute 'run_composer' do
      cwd current_release
      command 'composer install'
      action :run
    end
  end
end
