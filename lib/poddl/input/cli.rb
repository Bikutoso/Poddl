# frozen_string_literal: true

require_relative "../word"

module Poddl
  module Input
    # Input from Command Line.
    class CLI < Poddl::Input::Handler
      def run
        download(Poddl::Word.new(*@options.word))
      end
    end
  end
end
