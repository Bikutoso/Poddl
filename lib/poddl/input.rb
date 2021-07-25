# frozen_string_literal: true

require_relative "get"

module Poddl
  # This module handles various input methods
  module Input
    # Parent class of all handlers.
    class Handler
      def initialize(options)
        @options = options
        @poddl = Poddl::Get.new(Poddl::Word.new(*@options.word))
      end

      # Start the Handler
      def run
        warn "This is top level class"
      end
    end
  end
end

require_relative "input/cli"
require_relative "input/interactive"
require_relative "input/file"
