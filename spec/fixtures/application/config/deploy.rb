# frozen_string_literal: true

set :application, 'test_app'
set :composer_default_arguments, fetch(:composer_default_arguments) + ['-d=htdocs/']
SSHKit.config.command_map.prefix[:compass].push 'bundle exec'
SSHKit.config.command_map.prefix[:chown].push 'sudo'
SSHKit.config.command_map.prefix[:chgrp].push 'sudo'
SSHKit.config.command_map.prefix[:chmod].push 'sudo'
SSHKit.config.command_map[:composer] = 'php ./vendor/composer.phar'
SSHKit.config.command_map[:php] = '/usr/bin/php'
