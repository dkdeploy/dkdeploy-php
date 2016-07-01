Feature: Test tasks for namespace 'composer'

	Background:
		Given a test app with the default configuration

	Scenario: check for valid composer file
		Then a file named "htdocs/composer.json" should exist
		Then I successfully run `cap dev composer:local:validate`
		Then the output should contain "composer.json is valid"

	Scenario: Check if composer status is successful
		Given the default aruba exit timeout is 120 seconds
		And I successfully run `cap dev composer:local:run['install']`
		When I successfully run `cap dev composer:local:check_status`
		Then the output should contain "No local changes"

	Scenario: Check if composer status is not successful
		Given the default aruba exit timeout is 120 seconds
		When I run `cap dev composer:local:check_status`
		Then the exit status should not be 0
