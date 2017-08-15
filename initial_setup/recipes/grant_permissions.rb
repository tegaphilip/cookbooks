username = node[:deploy][:user]

user "#{username}" do
  group 'sudo'
  action :modify
end
