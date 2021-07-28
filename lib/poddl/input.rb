# frozen_string_literal: true

require_relative "downloader"

module Poddl
  # Module for various input methods
  module Input
    # Base object for all input handlers
    class Handler

      # Initialize instance with specified argument options
      # @param options [Poddl::Options] parsed optparse object
      def initialize(options)
        @options = options
      end

      # Runs selected handler
      # @return [0,1] return value
      def run
        0
      end

      private

      # Creates {Poddl::Downloader} and calls {Poddl::Downloader#download} 
      # with the save path specified in the options
      #
      # @param word [Poddl::Word] word object
      # @return [0,1] return value
      def get(word)
        Poddl::Downloader.new(word).download(@options.save_path)
      end
    end
  end
end

require_relative "input/cli"
require_relative "input/interactive"
require_relative "input/file"
