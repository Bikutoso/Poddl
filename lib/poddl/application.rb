# frozen_string_literal: true

require_relative "input"
require_relative "options"

module Poddl
  # Starts the application.
  #   It parses options, and slects an appropriate Input method
  class Application
    def initialize(argv)
      @options = Options.new(argv)
    end

    def run
      # NOTE: Currently only supports CLI input
      app = Poddl::Input::CLI.new(@options)
      app.run
    end
  end
end
