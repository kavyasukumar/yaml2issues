module Yaml2Issues
  # Exception class for various configuration problems
  class ConfigError < StandardError; end

  # Base exception class for all API Client exceptions
  class RequestError < StandardError
    attr_reader :response, :data, :path
    def initialize(response, path: nil)
      @response = response
      @path = path
      @data ||= begin
        JSON.parse(response.body)
      rescue
        {}
      end

      super("#{response.code} #{response.uri} #{response.body}")
    end
  end

  # Raised when there was something wrong with the request
  class BadRequest < RequestError; end

  # Raised when the authentication information is incorrect or incomplete
  class NotAllowed < RequestError; end

  # Raised when the requested thing is not found
  class NotFound < RequestError; end

  # Raised when the user is not authorized
  class NotAuthorized < RequestError; end

  # Raised when there is some sort of error on the server
  class ServerError < RequestError; end
end
