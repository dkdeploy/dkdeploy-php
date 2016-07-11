require 'capistrano/dkdeploy/core'

include Capistrano::DSL

# Load dkdeploy tasks
load File.expand_path('../../../dkdeploy/php/tasks/php.rake', __FILE__)
load File.expand_path('../../../dkdeploy/php/tasks/composer.rake', __FILE__)
load File.expand_path('../../../dkdeploy/php/tasks/db.rake', __FILE__)

namespace :load do
  task :defaults do
    set :composer_default_arguments, ['--no-interaction']
    set :composer_install_arguments, []

    set :doctrine_phar, './vendor/doctrine-migrations.phar'
    set :remote_migrations_root_directory, 'migrations'
    set :migrations_default_arguments, ['--no-interaction']

    set :remote_apc_file_name, 'apc_clear.php'
    set :local_apc_file, File.join(__dir__, '..', '..', '..', 'vendor', 'apc_clear.php')

    set :remote_opcache_file_name, 'opcache_reset.php'
    set :local_opcache_file, File.join(__dir__, '..', '..', '..', 'vendor', 'opcache_reset.php')

    # timeouts for Net::HTTP
    set :http_open_timeout, nil
    set :http_read_timeout, 60
  end
end
