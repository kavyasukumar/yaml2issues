require 'thor'
require 'json'
require 'yaml2issues'
require 'open3'

module Yaml2Issues
  # Have to namespace these classes, so we can name them what we want.
  # module CLI
    # DEFAULT_ISSUES_FILENAME = 'issues.yaml'.freeze

    class << self
      # Setup a place to stash a pseudo-global connection object
      attr_accessor :github

      # Used by extensions to register themselves as sub commands. Delagates
      # to AutotuneClient::CLI::Base.register (Thor method).
      #
      # Registers another Thor subclass as a command.
      #
      # ==== Parameters
      # klass<Class>:: Thor subclass to register
      # command<String>:: Subcommand name to use
      # usage<String>:: Short usage for the subcommand
      # description<String>:: Description for the subcommand
      def register(*args)
        Yaml2Issues.register(*args)
      end
    end
  # end
end

# require 'yaml2issues/cli/base'
# require 'yaml2issues/cli/yaml2issuescli'
