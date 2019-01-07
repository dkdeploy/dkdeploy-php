# frozen_string_literal: true

module Dkdeploy
  module Php
    module Helpers
      # DB related helpers
      module DB
        # Local migrations classes directory
        #
        # @return [String]
        def local_migrations_root_directory
          File.join 'config', 'migrations'
        end

        # Local migrations classes directory
        #
        # @return [String]
        def local_migrations_classes_directory
          File.join local_migrations_root_directory, 'classes'
        end

        # Local migrations stages directory
        #
        # @return [String]
        def local_migrations_stage_directory
          File.join local_migrations_root_directory, 'stage'
        end

        # Remote migrations root directory
        #
        # @return [String]
        def remote_migrations_root_directory
          File.join shared_path, fetch(:remote_migrations_root_directory)
        end

        # Remote migrations classes directory
        #
        # @return [String]
        def remote_migrations_classes_directory
          File.join(remote_migrations_root_directory, 'classes')
        end
      end
    end
  end
end
