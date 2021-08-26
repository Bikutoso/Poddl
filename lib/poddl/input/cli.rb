# frozen_string_literal: true

require_relative "../word"
require_relative "common"

module Poddl
  module Input
    # Handles the input from the command line interface
    class CLI
      include Poddl::Input::Common

      # Initialize instance with specified argument options
      # @param options [Poddl::Options] parsed optparse object
      def initialize(options)
        @options = options
      end

      # Calls {Poddl::Input::Handler#get} the word specified word.
      # @return [0,1] reutrn value
      # @see Poddl::Input::Handler#run
      def run
        word = Poddl::Word.new(*@options.word)
        get(word)
      end
    end
  end
end
