# update apt packages
include_recipe 'apt'

# Create unix user for tests
user 'test-user' do
  action :create
end

group 'test-group' do
  action :create
  append true
  members 'test-user'
end

group 'www-data' do
  action :create
  append true
  members 'vagrant'
end

# PHP
include_recipe 'php'
include_recipe 'php::module_mysql'

mysql_service 'default' do
  port '3306'
  # Need for remote connection
  bind_address '0.0.0.0'
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_connection_info = {
  :host     => '127.0.0.1',
  :username => 'root',
  :password => 'ilikerandompasswords'
}

mysql_database_user 'root' do
  connection mysql_connection_info
  host       '%'
  password   'ilikerandompasswords'
  action     :create
  privileges [:all]
  action     :grant
end

mysql_database 'dkdeploy_php' do
  connection mysql_connection_info
  action     :create
end

# Apache
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'

# install apache2-utils. It is needed for the assets:add_htpasswd task
package 'apache2-utils' do
  action :install
end

web_app 'dkdeploy-php.dev' do
  server_name 'dkdeploy-php.dev'
  server_aliases ['second-dkdeploy-php.dev']
  docroot '/var/www/dkdeploy/current/'
  template 'web_app.conf.erb'
end

directory '/var/www/' do
  owner 'vagrant' # deployment is done by vagrant user
  group 'www-data' # apache2 is executed by www-data and needs access to directory
  mode '0770'
  action :create
end
