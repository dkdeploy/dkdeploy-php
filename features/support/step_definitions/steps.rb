require 'erb'
require 'ostruct'

# Creates an empty doctrine migration with a given migration version and basic content
#
# @yieldparam migration_version [String] the 14 digits migration number
Given(/^an empty doctrine migration with name "([^"]*)"$/) do |file_path|
  context_object = OpenStruct.new migration_name: file_path.scan(/Version[0-9]+/)[0]
  def context_object.binding_for_erb
    binding
  end
  empty_doctrine_migration_template_path = File.expand_path('../../templates/empty-doctrine-migration.erb', __FILE__)
  empty_doctrine_migration_template = ERB.new File.read(empty_doctrine_migration_template_path)
  write_file file_path, empty_doctrine_migration_template.result(context_object.binding_for_erb)
end
