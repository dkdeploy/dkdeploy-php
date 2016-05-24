Feature: Test tasks for namespace 'php'

	Background:
		Given a test app with the default configuration
		And the default aruba exit timeout is 120 seconds
		And I successfully run `cap dev deploy`

	Scenario: Clear APC cache on the server
		When I run `cap dev php:clear_apc_cache`
		Then the exit status should be 0

	Scenario: Clear APC fails on non existing PHP file
		When I run `cap dev php:clear_apc_cache['htdocs/apc_clear.php']`
		Then the exit status should not be 0

	Scenario: Clear APC use server domain configuration
		And I extend the development capistrano configuration from the fixture file server_with_valid_domain.rb
		When I run `cap dev php:clear_apc_cache`
		Then the exit status should be 0
		And the output should contain "200 - OK"

	Scenario: Clear APC break non not valid configuration
		And I extend the development capistrano configuration from the fixture file server_with_faulty_domain_configuration.rb
		When I run `cap dev php:clear_apc_cache`
		Then the exit status should not be 0

	Scenario: Clear OPcache on the server
		When I run `cap dev php:clear_opcache`
		Then the exit status should be 0

	Scenario: Clear OPcache fails on non existing PHP file
		When I run `cap dev php:clear_opcache['htdocs/opcache_reset.php']`
		Then the exit status should not be 0

	Scenario: Clear OPcache use server domain configuration
		And I extend the development capistrano configuration from the fixture file server_with_valid_domain.rb
		When I run `cap dev php:clear_opcache`
		Then the exit status should be 0
		And the output should contain "200 - OK"

	Scenario: Clear OPcache break non not valid configuration
		And I extend the development capistrano configuration from the fixture file server_with_faulty_domain_configuration.rb
		When I run `cap dev php:clear_opcache`
		Then the exit status should not be 0

	Scenario: Clear APC via HTTPS
		Given a directory named "temp"
		And I extend the development capistrano configuration from the fixture file server_with_ssl.rb
	    And I inject the root SSL certificate
		When I run `cap dev php:clear_apc_cache`
		Then the exit status should be 0
		And the output should contain "200 - OK"

	Scenario: Clear APC via HTTPS and failing SSL certificate
		Given a directory named "temp"
		And I extend the development capistrano configuration from the fixture file server_with_ssl.rb
		When I run `cap dev php:clear_apc_cache`
		Then the exit status should not be 0
		And the output should contain "certificate verify failed"
