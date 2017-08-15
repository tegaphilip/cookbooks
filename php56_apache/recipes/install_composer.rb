username = node[:deploy][:user]

execute 'Install Composer' do
  command 'curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer'
  action :run
  not_if 'which composer'
end
