# frozen_string_literal: true

require 'i18n'

en = {
  tasks: {
    composer: {
      local: {
        check_status: {
          run_install: 'Please run command "%{command}"',
          failure: %q(You can't deploy Packages with local changes. Please run command "%{command}" to see which files are modified.')
        }
      }
    },
    php: {
      clear_apc_cache: {
        local_apc_file: 'Please enter the path to local apc clear cache file ',
        result_msg: 'Result %{code} - %{message}',
        cache_not_cleared: 'Can not clear apc cache. Result code is 2xx, but cache is not cleared. See php log for more information.',
        response_not_success: 'Can not clear apc cache. Result code is not 2xx. %{code} - %{message}'
      },
      clear_opcache: {
        local_opcache_file: 'Please enter the path to local OPcache clear cache file ',
        result_msg: 'Result %{code} - %{message}',
        cache_not_cleared: 'Can not clear OPcache. Result code is 2xx, but cache is not cleared. See php log for more information.',
        response_not_success: 'Can not clear OPcache. Result code is not 2xx. %{code} - %{message}'
      }
    },
    db: {
      migrations: {
        generate: {
          info: 'Generating new migration.'
        },
        status: {
          info: 'Getting status of migrations.'
        },
        migrate: {
          info: 'Migrating database.'
        },
        execute_down: {
          info: 'Migrating down to version %{migration_version}',
          abort: "Please set the variable 'migration_version' before you execute the task"
        },
        copy_doctrine_to_server: {
          info: {
            doctrine_phar: '%{doctrine_phar} found.',
            remove: 'Removing old migrations.',
            create_directories: 'Creating directories for migrations.',
            upload_doctrine: 'Copying doctrine-migrations.phar to %{migrations_root_directory} directory.',
            upload_doctrine_configuration: 'Copying configuration.yml to %{migrations_root_directory}.',
            upload_doctrine_db_configuration: 'Copying db-configuration.php to %{migrations_root_directory}.'
          }
        },
        copy_migrations_to_server: {
          info: {
            upload_migrations: 'Uploading migrations to %{migrations_classes_directory}.',
            upload_stage_migrations: 'Uploading migrations for stage %{stage} to %{migrations_classes_directory}.'
          }
        }
      }
    }
  },
  questions: {
    db: {
      migrations: {
        migration_version: 'Please enter the doctrine migration version:'
      }
    }
  }
}

I18n.backend.store_translations(:en, dkdeploy: en)

I18n.enforce_available_locales = true if I18n.respond_to?(:enforce_available_locales=)
