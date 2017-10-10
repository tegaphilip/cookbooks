include_attribute 'initial_setup::default'

default[:deploy]  = node[:deploy]
default[:apache2] = node[:apache2]
default[:php_ini] = node[:php_ini]
