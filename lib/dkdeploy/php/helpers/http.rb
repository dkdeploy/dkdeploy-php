require 'socket'
require 'net/http'

module Dkdeploy
  module Php
    module Helpers
      # HTTP related helpers
      module Http
        # Local migrations classes directory
        #
        # @param filename [String]
        # @param server [SSHKit::Host]
        # @return [Net::HTTPResponse]
        def call_file_on_server(filename, server)
          # Setting up URL to call
          domain_scheme = server.properties.respond_to?(:domain_scheme) ? server.fetch(:domain_scheme) : 'http'
          domain = server.properties.respond_to?(:domain) ? server.fetch(:domain) : server.hostname
          web_server_port = domain_scheme == 'https' ? 443 : 80
          # Use server configuration, if exists
          web_server_port = server.fetch(:web_server_port) if server.properties.respond_to?(:web_server_port)
          ssl_verify_mode = server.properties.respond_to?(:ssl_verify_mode) ? server.fetch(:ssl_verify_mode) : OpenSSL::SSL::VERIFY_PEER

          url = URI.parse("#{domain_scheme}://#{domain}").merge("/#{filename}")
          url.port = web_server_port
          info "Call URL #{url}"

          http_get_with_redirect url: url, verify_mode: ssl_verify_mode
        end

        # Sends a get request that handles redirects
        #
        # @param url [URI]
        # @param limit [Integer] defines how many redirects are allowed
        # @param verify_mode [OpenSSL::SSL::verify_mode] ssl verify mode, setting to VERIFY_NONE disables certificate check
        # @return [NET::HTTPResponse]
        def http_get_with_redirect(url:, limit: 5, verify_mode: OpenSSL::SSL::VERIFY_PEER)
          limit = Integer(limit)
          raise ArgumentError, 'limit cannot be negative' if limit < 0
          raise 'too many HTTP redirects' if limit.zero?
          # configure Net::HTTP
          http = Net::HTTP.new(url.host, url.port)
          http.open_timeout = fetch :http_open_timeout
          http.read_timeout = fetch :http_read_timeout
          if url.scheme == 'https'
            http.use_ssl = true
            http.verify_mode = verify_mode
          end
          request = Net::HTTP::Get.new(url.path) # build request
          response = http.request(request) # call url
          if response.is_a? Net::HTTPRedirection
            # Does not handle multiple redirects. Code/idea from http://stackoverflow.com/a/7210600/1796645
            location = URI.parse(response.header['location'])
            info "redirected to #{location}"
            response = http_get_with_redirect(url: location, limit: limit - 1, verify_mode: verify_mode)
          end
          response
        end
      end
    end
  end
end
