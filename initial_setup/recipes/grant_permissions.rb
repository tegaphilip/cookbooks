require 'digest/sha2'

deploy_user = node[:deploy][:user]

tunnel_user = node[:hocaboo][:users][:tunnel][:username]
tunnel_user_password = node[:hocaboo][:users][:tunnel][:password]
salt = rand(36**8).to_s(36)
shadow_hash = tunnel_user_password.crypt("$6$" + salt)

user "#{deploy_user}" do
  group 'sudo'
  home "/home/#{deploy_user}"
  action :modify
end

user "#{tunnel_user}" do
  group 'sudo'
  home "/home/#{tunnel_user}"
  action :create
  password shadow_hash
end
