# frozen_string_literal: true

require "optparse"

module Poddl
  # Defines and parses options
  class Options
    # Default path for downloads
    DEFAULT_PATH = "#{Dir.home}/Downloads"

    # Save path for downloads
    attr_reader :save_path
    # Array containing a kana (and a kanji)
    attr_reader :word

    # Initialize instance
    #
    # @param argv [argv] CLI arguments
    def initialize(argv)
      @save_path = ENV.key?("PODDL_PATH") ? ENV["PODDL_PATH"] : DEFAULT_PATH

      
      parse(argv)
      @word = argv
    end

    private

    # Parse the options with specified parameters
    #
    # @param argv [argv] CLI arguments
    # @return [Array] word arguments
    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: poddl [options] kana [kanji]"

        opts.on("-d", "--directory path", String,
                "Path to download directory") do |path|
          @save_path = path
        end

        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          warn "#{e.message}\n #{opts}"
          exit(-1)
        end
      end
    end
  end
end
