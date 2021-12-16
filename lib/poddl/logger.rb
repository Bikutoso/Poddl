# frozen_string_literal: true

require "date"

module Poddl
  # Defines various logging methods
  module Logger
    # Prints log messages
    #
    # @param msg [String] Message to print
    # @return [false]
    def self.log(msg)
      msg = "#{DateTime.now}: #{msg}" if $VERBOSE
      puts msg
    end

    # Prints error messages
    #
    # @param msg [String, nil] Error to print
    # @return [true] Returns true as it's an error
    def self.error(msg = nil)
      msg = "#{DateTime.now}: #{msg}" if $VERBOSE && !msg.nil?
      !(warn msg)
    end

    # Prints debug messages if $DEBUG is true
    #
    # @param msg [String] Debug Message to print
    # @return [0]
    def self.debug(msg)
      puts "#{DateTime.now}: #{msg}" if $DEBUG
    end

    # Prints verbose messages if $VERBOSE is true
    #
    # @param msg [String] Debug Message to print
    # @return [0]
    def self.verbose(msg)
      puts "#{DateTime.now}: #{msg}" if $VERBOSE
    end
  end
end
