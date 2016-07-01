Feature: Test tasks for namespace 'db'

	Background:
		Given a test app with the default configuration
		And I want to use the database `dkdeploy_php`
		And I successfully run `cap dev "db:upload_settings[127.0.0.1,3306,dkdeploy_php,root,ilikerandompasswords,utf8]"`

		Scenario Outline: Check if the basic file structure for doctrine migrations has been successfully created on the server
			When I successfully run `cap dev db:migrations:copy_doctrine_to_server`
			Then a remote file named "<remote_directory>/<target_file>" should exist
			And a remote directory named "migrations_path/classes" should exist

			Examples:
				| target_file               | remote_directory |
				| doctrine-migrations.phar  | migrations_path  |
				| cli-config.php            | migrations_path  |
				| migrations.yml            | migrations_path  |

		Scenario Outline: Check the correct stage specifig configuration of remote migrations root directory
			When I extend the development capistrano configuration variable remote_migrations_root_directory with value 'alternative_migrations_directory'
			And I successfully run `cap dev db:migrations:copy_doctrine_to_server`
			Then a remote file named "<remote_directory>/<target_file>" should exist
			And a remote directory named "shared_path/alternative_migrations_directory/classes" should exist

			Examples:
				| target_file               | remote_directory                             |
				| doctrine-migrations.phar  | shared_path/alternative_migrations_directory |
				| cli-config.php            | shared_path/alternative_migrations_directory |
				| migrations.yml            | shared_path/alternative_migrations_directory |

		Scenario: Check if a generated migration has benn successfully downloaded to the local directory config/migrations/classes
			When I successfully run `cap dev db:migrations:generate`
			And a file matching %r</migrations/classes/Version.+.php> should exist

		Scenario: Checking if the migrations status table is outputed on the console
			When I successfully run `cap dev db:migrations:status`
			Then the output should contain "Doctrine TYPO3 Migrations"

		Scenario: Checking if only global and current stage specific doctrine migrations are uploaded on the server
			Given an empty doctrine migration with name "config/migrations/classes/Version99999999999997.php"
			And an empty doctrine migration with name "config/migrations/stage/dev/Version99999999999998.php"
			And an empty doctrine migration with name "config/migrations/stage/integration/Version99999999999999.php"
			When I successfully run `cap dev db:migrations:copy_migrations_to_server`
			Then a remote file named "migrations_path/classes/Version99999999999997.php" should exist
			And a remote file named "migrations_path/classes/Version99999999999998.php" should exist
			And a remote file named "migrations_path/classes/Version99999999999999.php" should not exist

		Scenario: Check if migrations copied recursive to server
			Given an empty doctrine migration with name "config/migrations/classes/Version99999999999997.php"
			And an empty doctrine migration with name "config/migrations/classes/test1/Version99999999999997.php"
			And an empty doctrine migration with name "config/migrations/classes/test1/test2/Version99999999999997.php"
			And an empty doctrine migration with name "config/migrations/classes/test3/Version99999999999997.php"
			And an empty doctrine migration with name "config/migrations/stage/dev/Version99999999999998.php"
			And an empty doctrine migration with name "config/migrations/stage/dev/test1/test2/Version99999999999998.php"
			And an empty doctrine migration with name "config/migrations/stage/dev/test4/Version99999999999998.php"
			When I successfully run `cap dev db:migrations:copy_migrations_to_server`
			Then a remote file named "migrations_path/classes/Version99999999999997.php" should exist
			And a remote file named "migrations_path/classes/Version99999999999998.php" should exist
			And a remote file named "migrations_path/classes/test1/Version99999999999997.php" should exist
			And a remote file named "migrations_path/classes/test1/test2/Version99999999999997.php" should exist
			And a remote file named "migrations_path/classes/test1/test2/Version99999999999998.php" should exist
			And a remote file named "migrations_path/classes/test3/Version99999999999997.php" should exist
			And a remote file named "migrations_path/classes/test4/Version99999999999998.php" should exist

		Scenario: Checking if executed migrations result in database entries
			Given an empty doctrine migration with name "config/migrations/stage/dev/Version22222222222222.php"
			And an empty doctrine migration with name "config/migrations/stage/dev/Version33333333333333.php"
			When I successfully run `cap dev db:migrations:copy_migrations_to_server`
			And I successfully run `cap dev db:migrations:migrate`
			Then the database should have a value `22222222222222` in table `doctrine_migrations` for column `version`

		Scenario: Checking if downgraded migration is deleted from migrations table, but not other migrations
			Given an empty doctrine migration with name "config/migrations/stage/dev/Version22222222222222.php"
			And an empty doctrine migration with name "config/migrations/stage/dev/Version33333333333333.php"
			And an empty doctrine migration with name "config/migrations/stage/dev/Version44444444444444.php"
			When I successfully run `cap dev db:migrations:copy_migrations_to_server`
			And I successfully run `cap dev db:migrations:migrate`
			And I run `cap dev db:migrations:execute_down` interactively
			And I type "33333333333333"
			And I close the stdin stream
			And I wait 10 seconds to let the database commit the transaction
			Then the database should not have a value `33333333333333` in table `doctrine_migrations` for column `version`
			And the database should have a value `22222222222222` in table `doctrine_migrations` for column `version`
			And the database should have a value `44444444444444` in table `doctrine_migrations` for column `version`
