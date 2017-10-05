require 'socket'
require 'net/http'
require 'uri'
require 'json'
require 'dkdeploy/php/helpers/http'
include Dkdeploy::Php::Helpers::Http

namespace :php do
  desc 'Show PHP Version'
  task :version do
    on roles :app, :web do
      php_version = capture :php, '-v'
      info php_version
    end
  end

  desc 'Clear APC cache on stage'
  task :clear_apc_cache, :local_apc_file do |_, args|
    local_apc_file = ask_variable(args, :local_apc_file, 'tasks.php.clear_apc_cache.local_apc_file') { |question| question.default = 'vendor/apc_clear.php' }

    web_root = File.join current_path, fetch(:remote_web_root_path)
    remote_apc_file_name = fetch(:remote_apc_file_name)
    remote_apc_file = File.join web_root, remote_apc_file_name

    on roles :app do |server|
      delete_apc_file = false
      unless test("[ -f #{remote_apc_file} ]")
        # upload file, if not exists
        upload! local_apc_file, remote_apc_file, via: :scp
        delete_apc_file = true
      end

      begin
        # call url
        response = call_file_on_server remote_apc_file_name, server
        info I18n.t('tasks.php.clear_apc_cache.result_msg', code: response.code, message: response.message, scope: :dkdeploy)
        if response.is_a? Net::HTTPSuccess
          result = JSON.parse response.body
          unless result['success']
            warn I18n.t('tasks.php.clear_apc_cache.cache_not_cleared', scope: :dkdeploy)
          end
        else
          error I18n.t('tasks.php.clear_apc_cache.response_not_success', code: response.code, message: response.message, scope: :dkdeploy)
          raise
        end
      ensure
        # Delete file, if uploaded before
        execute(:rm, '-f', remote_apc_file) if delete_apc_file
      end
    end
  end

  desc 'Clear OPcache on stage'
  task :clear_opcache, :local_opcache_file do |_, args|
    local_opcache_file = ask_variable(args, :local_opcache_file, 'tasks.php.clear_opcache.local_opcache_file') { |question| question.default = 'vendor/opcache_reset.php' }

    web_root = File.join current_path, fetch(:remote_web_root_path)
    remote_opcache_file_name = fetch(:remote_opcache_file_name)
    remote_opcache_file = File.join web_root, remote_opcache_file_name

    on roles :app do |server|
      delete_opcache_file = false
      unless test("[ -f #{remote_opcache_file} ]")
        # upload file, if not exists
        upload! local_opcache_file, remote_opcache_file, via: :scp
        delete_opcache_file = true
      end

      begin
        # call url
        response = call_file_on_server remote_opcache_file_name, server
        info I18n.t('tasks.php.clear_opcache.result_msg', code: response.code, message: response.message, scope: :dkdeploy)
        if response.is_a? Net::HTTPSuccess
          result = JSON.parse response.body
          unless result['success']
            warn I18n.t('tasks.php.clear_opcache.cache_not_cleared', scope: :dkdeploy)
          end
        else
          error I18n.t('tasks.php.clear_opcache.response_not_success', code: response.code, message: response.message, scope: :dkdeploy)
          raise
        end
      ensure
        # Delete file, if uploaded before
        execute(:rm, '-f', remote_opcache_file) if delete_opcache_file
      end
    end
  end
end
