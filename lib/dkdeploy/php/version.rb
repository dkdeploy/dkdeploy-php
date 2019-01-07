# frozen_string_literal: true

module Dkdeploy
  module Php
    # Class for version number
    #
    class Version
      MAJOR = 8
      MINOR = 0
      PATCH = 0

      def self.to_s
        "#{MAJOR}.#{MINOR}.#{PATCH}"
      end
    end
  end
end
