# frozen_string_literal: true

require_relative "downloader"

module Poddl
  # This module handles various input methods
  module Input
    # Parent class of all handlers.
    class Handler
      def initialize(options)
        @options = options
      end

      # Run the specified handler
      def run
        nil
      end

      private

      # This creates and calls the Dorwnloader to start downloading.
      def get(word)
        Poddl::Downloader.new(word).download(@options.save_path)
      end
    end
  end
end

require_relative "input/cli"
require_relative "input/interactive"
require_relative "input/file"
