# frozen_string_literal: true

require_relative "common"

module Poddl
  module Input
    # Handles the input from a file
    class File
      include Poddl::Input::Common

      # Initialize instance with specified argument options
      # @param options [Poddl::Options] parsed optparse object
      def initialize(options)
        @options = options
      end

      # Calls {Poddl::Input::Handler#get} the word specified word.
      # @return [Boolean] reutrn value
      # @see Poddl::Input::Handler#run
      def run
        puts "Got #{@options.input_file}!"
        0
      end
    end
  end
end
