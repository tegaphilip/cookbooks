include_attribute 'initial_setup::default'

default[:deploy]  = node[:deploy]
default[:apache2] = node[:apache2]
