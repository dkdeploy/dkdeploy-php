# frozen_string_literal: true

require 'erb'
require 'dkdeploy/php/helpers/db'
include Dkdeploy::Php::Helpers::DB

namespace :db do
  desc 'Database migrations with Doctrine2. See http://www.doctrine-project.org/projects/migrations'
  namespace :migrations do
    desc 'Generate and download new migration'
    task generate: [:copy_doctrine_to_server] do
      on primary :backend do
        info I18n.t('tasks.db.migrations.generate.info', scope: :dkdeploy)
        execute :mkdir, '-p', remote_migrations_root_directory
        within remote_migrations_root_directory do
          execute :php, 'doctrine-migrations.phar', 'migrations:generate', fetch(:migrations_default_arguments)
        end
        download! remote_migrations_classes_directory, local_migrations_root_directory, via: :scp, recursive: true
      end
    end

    desc 'Show migration status'
    task status: %i[copy_doctrine_to_server copy_migrations_to_server] do
      run_locally do
        info I18n.t('tasks.db.migrations.status.info', scope: :dkdeploy)
      end
      on primary :backend do
        within remote_migrations_root_directory do
          execute :php, 'doctrine-migrations.phar', 'migrations:status'
        end
      end
    end

    desc 'Migrate Database'
    task migrate: %i[copy_doctrine_to_server copy_migrations_to_server] do
      run_locally do
        info I18n.t('tasks.db.migrations.migrate.info', scope: :dkdeploy)
      end
      on primary :backend do
        within remote_migrations_root_directory do
          execute :php, 'doctrine-migrations.phar', 'migrations:migrate', fetch(:migrations_default_arguments)
        end
      end
    end

    desc 'Downgrade database'
    task :execute_down, :migration_version do |_, args|
      migration_version = ask_variable(args, :migration_version, 'questions.db.migrations.migration_version')
      invoke 'db:migrations:copy_doctrine_to_server'
      invoke 'db:migrations:copy_migrations_to_server'
      run_locally do
        info I18n.t('tasks.db.migrations.execute_down.info', migration_version: migration_version, scope: :dkdeploy)
      end
      on primary :backend do
        within remote_migrations_root_directory do
          execute :php, 'doctrine-migrations.phar', 'migrations:execute', migration_version.to_s, '--down', fetch(:migrations_default_arguments)
        end
      end
    end

    desc 'Copy Doctrine to server'
    task :copy_doctrine_to_server do
      if File.exist? fetch(:doctrine_phar)
        run_locally do
          info I18n.t('tasks.db.migrations.copy_doctrine_to_server.info.doctrine_phar',
                      doctrine_phar: fetch(:doctrine_phar),
                      scope: :dkdeploy)
        end
        on primary :backend do
          info I18n.t('tasks.db.migrations.copy_doctrine_to_server.info.remove', scope: :dkdeploy)
          execute :rm, '-rf', remote_migrations_root_directory
          info I18n.t('tasks.db.migrations.copy_doctrine_to_server.info.create_directories', scope: :dkdeploy)
          execute :mkdir, '-p', remote_migrations_classes_directory

          info I18n.t('tasks.db.migrations.copy_doctrine_to_server.info.upload_doctrine',
                      migrations_root_directory: remote_migrations_root_directory,
                      scope: :dkdeploy)
          upload! fetch(:doctrine_phar), File.join(remote_migrations_root_directory, 'doctrine-migrations.phar')

          info I18n.t('tasks.db.migrations.copy_doctrine_to_server.info.upload_doctrine_db_configuration',
                      migrations_root_directory: remote_migrations_root_directory,
                      scope: :dkdeploy)
          cli_config_template = ERB.new File.read(File.join(local_migrations_root_directory, 'cli-config.php.erb'))
          upload! StringIO.new(cli_config_template.result(binding)), File.join(remote_migrations_root_directory, 'cli-config.php')

          I18n.t('tasks.db.migrations.copy_doctrine_to_server.info.upload_doctrine_configuration',
                 migrations_root_directory: remote_migrations_root_directory,
                 scope: :dkdeploy)
          cli_config_template = ERB.new File.read(File.join(local_migrations_root_directory, 'migrations.yml.erb'))
          upload! StringIO.new(cli_config_template.result(binding)), File.join(remote_migrations_root_directory, 'migrations.yml')
        end
      end
    end

    desc 'Copies your Doctrine migrations to server'
    task :copy_migrations_to_server do
      on primary :backend do
        info I18n.t('tasks.db.migrations.copy_migrations_to_server.info.upload_migrations',
                    migrations_classes_directory: remote_migrations_classes_directory,
                    scope: :dkdeploy)
        execute :rm, '-rf', remote_migrations_classes_directory

        # Copy common migrations to server
        upload! local_migrations_classes_directory, remote_migrations_root_directory, via: :scp, recursive: true if Dir.exist? local_migrations_classes_directory

        # Copy stage specific migrations
        if Dir.exist? File.join(local_migrations_stage_directory, fetch(:stage).to_s)
          info I18n.t('tasks.db.migrations.copy_migrations_to_server.info.upload_stage_migrations',
                      stage: fetch(:stage).to_s,
                      migrations_classes_directory: remote_migrations_classes_directory,
                      scope: :dkdeploy)
          execute :mkdir, '-p', remote_migrations_classes_directory
          local_stage_directory = File.join(local_migrations_stage_directory, fetch(:stage).to_s)
          Dir[File.join(local_stage_directory, '*')].each do |file|
            upload! file, remote_migrations_classes_directory, via: :scp, recursive: true
          end
        end
      end
    end
  end
end
