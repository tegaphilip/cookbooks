default[:deploy]  = {}
default[:deploy][:user]  = 'devteam'
default[:apache2_dir] = '/etc/apache2'
default[:server_admin] = 'devteam@hocaboo.com'
default[:deploy][:document_root] = '/var/www/html/hocaboo-api/current'


default[:apache2] = {
  :error_log_dir => '/var/log/apache2/error.log',
  :access_log_dir => '/var/log/apache2/access.log',
  :mod_enable_path => '/etc/apache2/mods-enabled',
  :sites_available_path => '/etc/apache2/sites-available',
}


include_attribute "initial_setup::customize"
