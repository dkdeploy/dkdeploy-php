# frozen_string_literal: true

require 'dkdeploy/helpers/common'
require 'capistrano/i18n'
require 'dkdeploy/php/i18n'

include Dkdeploy::Helpers::Common

namespace :composer do
  namespace :local do
    desc 'Check the status of the composer.json file'
    task :check_status do
      default_arguments = fetch(:composer_default_arguments)
      install_arguments = fetch(:composer_install_arguments)

      run_locally do
        # Try dry install --dry-run
        output = capture :composer, :install, '--dry-run', *install_arguments, *default_arguments, '2>&1', verbosity: SSHKit::Logger::INFO
        unless output.include? 'Nothing to install or update'
          command = SSHKit::Command.new :composer, :install, *install_arguments, *default_arguments
          error I18n.t('tasks.composer.local.check_status.run_install', command: command.to_s, scope: :dkdeploy)
          exit 1
        end
      end

      begin
        # run composer status
        invoke 'composer:local:run', :status
      rescue SSHKit::StandardError
        run_locally do
          command = SSHKit::Command.new :composer, :status, '-v', *default_arguments
          error I18n.t('tasks.composer.local.check_status.failure', command: command.to_s, scope: :dkdeploy)
          exit 1
        end
      end
    end

    desc 'Validate composer file'
    task :validate do
      invoke 'composer:local:run', :validate
    end

    desc 'Execute composer command'
    task :run, :command do |_t, args|
      args.with_defaults(command: :list, verbosity: :debug)
      default_arguments = fetch(:composer_default_arguments)
      run_locally do
        execute :composer, args[:command], *args.extras, *default_arguments, '2>&1'
      end
    end
  end
end
