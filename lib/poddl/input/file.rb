# frozen_string_literal: true

require "csv"

require_relative "../logger"

module Poddl
  module Input
    # Handles the input from a file
    class File
      # NOTE: Common is removed as we handle the downloading manually
      # Are there ways we move parts of it into common?

      include Logging

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
        generate_words(@options.input_file).each { |word| q << word }

        dw = Poddl::Downloader.new(@options)

        thread_download(q, dw)

        q.close # Necessary to close?
        # TODO: This currently always successfull. Make it return when failed
        0
      end

      private

      # Starts threads with downloader
      # @param q [Queue] work queue
      # @param q [Poddl:Downloader] downloader
      # @return [Boolean] success?
      def thread_download(q, dw)
        threads = []
        @options.threads.times do
          threads << Thread.new do
            # We loop queue untill there is no items left
            dw.download(q.pop, @options.save_path) until q.empty?
          end
        end
        threads.each(&:join)
        0
      end

      # Parses a CSV file from file
      # @param path [String] CSV file to parse
      # @return [Array<Poddl:Word>] array of words
      def generate_words(path)
        words = []
        CSV.read(path).each do |word|
          words.append(Poddl::Word.new(word))
          logger.debug "Generated word:#{word}, #{words[-1]}"
        end
        # I feel there is a way to use the each loop instead of mentioning the array here.
        words
      end
    end
  end
end
