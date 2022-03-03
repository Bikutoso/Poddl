# frozen_string_literal: true

require_relative "../parse_csv"

module Poddl
  module Input
    # Handles the input from a file
    class File
      # NOTE: Common is removed as we handle the downloading manually
      # Are there ways we move parts of it into common?

      # Initialize instance with specified argument options
      # @param options [Poddl::Options] parsed optparse object
      def initialize(options)
        @options = options
      end

      # Calls {Poddl::Input::Handler#get} the word specified word.
      # @return [Boolean] reutrn value
      # @see Poddl::Input::Handler#run
      def run
        # Create and fill queue
        q = Queue.new
        ParseCSV.parse(@options.input_file).each { |word| q << word }

        dw = Poddl::Downloader.new(@options)
        threads = []
        @options.threads.times do
          threads << Thread.new do
            # We loop queue untill there is no items left
            dw.download(q.pop, @options.save_path) until q.empty?
          end
        end

        threads.each(&:join)
        q.close # Necessary to close?
        # TODO: This currently always successfull. Make it return when failed
        0
      end
    end
  end
end
