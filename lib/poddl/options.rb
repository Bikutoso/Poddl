# frozen_string_literal: true

require "optparse"

module Poddl
  # Creates options
  class Options
    # Current version of this application
    VERSION = "1.1.0-dev"

    # Defines Options
    class ScriptOptions
      # Default path for downloads
      DEFAULT_PATH = "#{Dir.home}/Downloads"

      # Default URL for downloads
      DEFAULT_SOURCE_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

      # SHA-256 for a file that's considered empty.
      # @note The actuall file from this hash is an audio clips that says:
      #   <em>"The audio for this clip is currently not available"</em>
      DEFAULT_SOURCE_HASH = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906"

      attr_accessor :save_path, :input_file, :url, :url_hash, :word

      # Default values
      def initialize
        # These options can be set via ENV, if so use them.
        self.save_path = ENV.key?("PODDL_PATH") ? ENV["PODDL_PATH"] : DEFAULT_PATH
        self.url = ENV.key?("PODDL_URL") ? ENV["PODDL_URL"] : DEFAULT_SOURCE_URL
        self.url_hash = ENV.key?("PODDL_HASH") ? ENV["PODDL_HASH"] : DEFAULT_SOURCE_HASH

        self.word = [nil, nil]
      end

      # Defines all options
      #
      # @param parser [OptionParser] undefined parser
      # @return [OptionParser] defined parser
      # @raise [OptionParser::MissingArgument] missing or incomplete arguments
      def define_options(parser)
        parser.banner = "Usage: poddl [options] [kana] [kanji]"
        parser.separator ""
        parser.separator "Specific options:"

        # Additonal options
        string_save_options(parser)
        string_input_file(parser)
        boolean_verbose_option(parser)

        parser.separator ""
        parser.separator "Common options:"

        # No argument show at tail. This will print an options summary.
        parser.on_tail("-h", "--help", "Show this message") do
          puts parser
          exit
        end

        # Show version
        parser.on_tail("-V", "--version", "Show version") do
          puts VERSION
          exit
        end
      end

      # Options for save path
      #
      # @param parser [OptionParser]
      def string_save_options(parser)
        parser.on("-d", "--directory path", String,
                  "Path to download directory") do |path|
          self.save_path = path
        end
      end

      def string_input_file(parser)
        parser.on("-i", "--input file", String,
                  "CSV file with words") do |path|
          self.input_file = path
        end
      end

      # Option for verbosity
      #
      # @param parser [OptionParser]
      def boolean_verbose_option(parser)
        parser.on("-v", "--[no-]verbose", "Run verbosely") do |verbose|
          # Update rubys $VERBOSE variable to update the user choice.
          # This will make it not bound for the options class,
          #   and can be used anywhere.
          $VERBOSE = verbose
        end
      end
    end

    # Return a structure describing the options
    #
    # @param args [Array] arguments (e.g. ARGV)
    # @return [Poddl::Options::ScriptOptions] finished options
    def parse(args)
      # Print help if empty arguments
      # args = ["-h"] if args.empty?
      @options = ScriptOptions.new
      @args = OptionParser.new do |parser|
        @options.define_options(parser)
        parser.parse!(args)

        # This becomes the word we want to download
        @options.word = args.first(2)
      rescue OptionParser::MissingArgument, OptionParser::InvalidArgument
        # HACK: This is a fucking stupid way to do it.
        #   It dosn't allow me to handle excpetions during parsing.
        parse(["-h"])
      end

      # Return options
      @options
    end

    attr_reader :parser, :options
  end
end
