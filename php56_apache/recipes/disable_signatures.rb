apache2_dir = node[:apache2_dir]
conf_file = apache2_dir + File::SEPARATOR  + 'apache2.conf'

if File.exist?(conf_file)
	execute 'Turn off Server Signature' do
		command "echo 'ServerSignature Off' >> #{conf_file}"
		action :run
		not_if "grep '^ServerSignature Off$' #{conf_file}"
	end

	execute 'Turn off Server Tokens' do
		command "echo 'ServerTokens Prod' >> #{conf_file}"
		action :run
		not_if "grep '^ServerTokens Prod$' #{conf_file}"
	end
end
