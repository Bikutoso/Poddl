# frozen_string_literal: true

require_relative "input"
require_relative "options"
require_relative "logger"

module Poddl
  # Slects and starts the apropriate handler based on arguments
  #
  # == Handlers
  # - Implemented
  # - - {Poddl::Input::CLI}: Download a word from command line
  # - - {Poddl::Input::Interactive}: Downloads words as questions in the program
  # - Not implemented
  # - - {Poddl::Input::File}: Downloads words from a file
  class Application
    include Logging

    # Initialize with options
    # @param argv [argv] CLI arguments
    def initialize(argv)
      @options = Options.new.parse(argv)
      logger.debug "Save Path: #{@options.save_path}"
      logger.debug "Input File: #{@options.input_file}"
      logger.debug "URL: #{@options.url}"
      logger.debug "HASH: #{@options.url_hash}"
    end

    # Starts the application
    #
    # @return [Boolean] return value
    # @raise [Interrupt] if terminated by user
    def run
      # Run in interactive mode if no word is specified
      app = if @options.input_file
              logger.info "Using File mode..."
              Poddl::Input::File.new(@options)
            elsif @options.word.none?
              logger.info "Using Interactive mode..."
              Poddl::Input::Interactive.new(@options)
            else
              logger.info "Using CLI mode..."
              Poddl::Input::CLI.new(@options)
            end

      app.run
    rescue Interrupt
      exit 0
    end
  end
end
