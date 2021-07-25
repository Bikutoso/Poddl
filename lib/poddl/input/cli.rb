# frozen_string_literal: true

require_relative "../word"

module Poddl
  module Input
    # Input from Command Line.
    class CLI < Poddl::Input::Handler
      def run
        @poddl.download(@options.save_path)
      end
    end
  end
end
