# frozen_string_literal: true

require_relative "input"
require_relative "options"

module Poddl
  # Slects and starts the apropriate handler based on arguments
  #
  # == Handlers
  # - Implemented
  # - - {Poddl::Input::CLI}: Download a word from command line
  # - Not implemented
  # - - {Poddl::Input::Interactive}: Downloads words as questions in the program
  # - - {Poddl::Input::File}: Downloads words from a file
  class Application
    # Initialize with options
    # @param argv [argv} CLI arguments
    def initialize(argv)
      @options = Options.new(argv)
    end

    # Starts the application
    #
    # @return [0,1] return value
    def run
      # NOTE: Currently only supports CLI input
      app = Poddl::Input::CLI.new(@options)
      app.run
    end
  end
end
