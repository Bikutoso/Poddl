# frozen_string_literal: true

require_relative "common"
require_relative "../parse_csv"

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
        words = ParseCSV.parse(@options.input_file)
        words.each do |word|
          get(word)
        end
        0
      end
    end
  end
end
