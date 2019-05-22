require 'uri'
require 'net/http'
require 'json'

require 'yaml2issues/errors'
require 'yaml2issues/base'

module Yaml2Issues
  DEFAULT_ISSUES_FILENAME = 'issues.yaml'.freeze

  # Shortcut to AutotuneClient::Base.new
  def self.new(*args, **kwargs)
    Base.new(*args, **kwargs)
  end
end
