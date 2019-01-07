# frozen_string_literal: true

require 'dkdeploy/test_environment/application'
ssh_config = {}

ssh_key_files = Dir.glob(File.join(Dir.getwd, '.vagrant', 'machines', '**', 'virtualbox', 'private_key'))
unless ssh_key_files.empty?
  # Define generated ssh key files
  ssh_config = {
    user: 'vagrant',
    keys: ssh_key_files
  }
end

TEST_APPLICATION = Dkdeploy::TestEnvironment::Application.new(File.expand_path('../..', __dir__), 'dkdeploy-php.dev', ssh_config)
TEST_APPLICATION.mysql_connection_settings = { host: 'dkdeploy-php.dev', username: 'root', password: 'ilikerandompasswords' }
