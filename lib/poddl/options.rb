# frozen_string_literal: true

require "optparse"

module Poddl
  # Defines and parses options
  class Options
    DEFAULT_PATH = "#{Dir.home}/Documents/Personal/Langauge/Japanese/Audio"
    attr_reader :save_path, :word

    def initialize(argv)
      @save_path = DEFAULT_PATH
      parse(argv)
      @word = argv
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: poddl [options] kana [kanji]"

        opts.on("-d", "--directory path", String, "Path to download directory") do |path|
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
