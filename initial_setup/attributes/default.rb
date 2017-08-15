default[:deploy]  = {}
default[:deploy][:user]  = 'devteam'

default[:apache2_dir] = '/etc/apache2'
default[:server_admin] = 'devteam@hocaboo.com'
default[:deploy][:document_root] = '/var/www/html/hocaboo_api/current'

include_attribute "initial_setup::customize"
