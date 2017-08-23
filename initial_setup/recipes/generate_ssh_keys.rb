username = node[:deploy][:user]
private_key_path = "/home/#{node[:deploy][:user]}/.ssh/id_rsa"
public_key_path = "/home/#{node[:deploy][:user]}/.ssh/id_rsa.pub"

bash 'generate ssh key pair' do
  user username
  code <<-EOH
    ssh-keygen -t rsa -q -f #{private_key_path} -P ""
    EOH
  not_if { ::File.exist?("#{private_key_path}") }
end

file "/home/#{node[:deploy][:user]}/.ssh/known_hosts" do
  action :create
end

# file = File.open(public_key_path, "rb")
# contents = file.read
#
# message = {'text' => contents}
# command_string = "curl -X POST -H 'Content-type: application/json' --data '" + message.to_json
#  + "' " + node[:hocaboo][:slack][:hooks_url]

# execute 'Send Public Key to Slack' do
#   command command_string
#   action :run
# end
