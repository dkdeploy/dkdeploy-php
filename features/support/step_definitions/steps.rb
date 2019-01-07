# frozen_string_literal: true

require 'erb'
require 'ostruct'

include Dkdeploy::TestEnvironment::Constants # to get access to test_app_path method
# Creates an empty doctrine migration with a given migration version and basic content
#
# @yieldparam migration_version [String] the 14 digits migration number
Given(/^an empty doctrine migration with name "([^"]*)"$/) do |file_path|
  context_object = OpenStruct.new migration_name: file_path.scan(/Version[0-9]+/)[0]
  def context_object.binding_for_erb
    binding
  end
  empty_doctrine_migration_template_path = File.expand_path('../templates/empty-doctrine-migration.erb', __dir__)
  empty_doctrine_migration_template = ERB.new File.read(empty_doctrine_migration_template_path)
  write_file file_path, empty_doctrine_migration_template.result(context_object.binding_for_erb)
end

Given(/^I set relative to current path the environment variable "(.*)" to "(.*)"/) do |variable, value|
  set_environment_variable(variable.to_s, test_app_path + value.to_s)
end

# injects the self-signed certificate into environment variables to simulate a valid certificate
Given('I inject the root SSL certificate') do
  steps 'When I run `cap dev utils:download_file[../../../dkdeploy.pem]`
         Given I set relative to current path the environment variable "SSL_CERT_FILE" to "/temp/dkdeploy.dkdeploy-php.dev.pem"'
end
