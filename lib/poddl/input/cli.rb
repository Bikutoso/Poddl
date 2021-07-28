# frozen_string_literal: true

require_relative "../word"

module Poddl
  module Input
    # Handles the input from the command line interface
    class CLI < Poddl::Input::Handler
      
      # Calls {Poddl::Input::Handler#get} the word specified word.
      # @return [0,1] reutrn value
      # @see Poddl::Input::Handler#run
      def run
        get(Poddl::Word.new(*@options.word))
      end
    end
  end
end
