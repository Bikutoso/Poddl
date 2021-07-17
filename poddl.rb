#!/usr/bin/env ruby
# frozen_string_literal: true

# License details:
#   AUTHOR: Victoria Solli
#   REPOSITORY: gist.github.com/Bikutoso/046f0bfebe9d12a13ce690586d65aff2
#   LICENSE: Unlicense (https://unlicense.org/)
#
# Script Information:
#   This is my first Ruby project. So it might not be have the best quality.
#   It's a remake of an old hacked together Python script that i previously used.
#   So i was a perfect first project for Ruby. Especially with the simplicity of open-uri and digest.
#   I'm releasing it under Unlicense (public domain) because i don't care how it's being used;
#   I just hope someone will find a use for it.

require "open-uri"
require "digest"

module PODDL
  # Word composed of Kanji and Kana
  class Word
    attr_reader :kana, :kanji

    # Assign value if input is only kana
    def kana=(kana)
      @kana = kana if valid?(kana, /^(?:\p{hiragana}|\p{katakana}|ー)+$/)
    end

    # Assign value if input is nil or only kanji
    def kanji=(kanji)
      @kanji = kanji if kanji.nil? || valid?(kanji, /^\p{han}+$/)
    end

    def initialize(kana, kanji = nil)
      self.kana = kana
      self.kanji = kanji
    end

    # Returns true if kana & kanji is defined
    def defined?
      # Double negate to return boolean
      !!(defined?(@kana) && defined?(@kanji))
    end

    # Return a formated uri query
    def encode
      # Only encode with kanji when necessary
      if @kanji.nil?
        "? #{URI.encode_www_form([['kana', @kana]])}"
      else
        "? #{URI.encode_www_form([['kana', @kana], ['kanji', @kanji]])}"
      end
    end

    # Formats @kana and @Kanji into simple a usable string
    def to_s
      @kanji.nil? ? "#{@kana}.mp3" : "#{@kanji}_#{@kana}.mp3"
    end

    private

    # Check if string is valid based on Regex
    def valid?(str, regex)
      str.match?(regex)
    end
  end

  # Downloads files from languagepod101 with specified kanji/kana
  class Get
    NOT_AVAILABLE_HASH = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906" # SHA-256
    TARGET_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

    attr_accessor :word

    def initialize(word)
      @word = word
    end

    # Prepeare and find issues before actuall downloading
    def download(path)
      unless File.directory?(path)
        warn "#{path} is not a valid directory"
        return 1
      end

      unless @word.defined?
        warn "Not a valid word"
        return 1
      end

      url_open(path)
    end

    private

    # Open url and check file hash of url
    def url_open(path)
      # OPTIMIZE: Store the file in a variable.
      #   It should possibly save a second download? (don't know how rewinds works)
      #   It will also remove the need for the url.rewind.
      #   And make it simpler to check with "file?"

      URI.parse(TARGET_URL + @word.encode).open do |url|
        unless file?(url)
          warn "Unable to find file: #{@word}"
          return 1
        end

        url.rewind
        url_save(url, path)
      end

    rescue SocketError, RuntimeError # Connection? Wrong URL?
      warn "Failed to open #{TARGET_URL}!"
    end

    # Open file and save output of the url
    def url_save(url, path)
      puts "Downloading: #{@word}"
      File.open("#{path}/#{@word}", "w") do |f|
        # Files are small enough to be saved in one part
        f.write(url.read) ? 0 : 1
      end

    rescue Errno::ENOENT, Errno::EACCES, Errno::EISDIR, Errno::ENOSPC
      warn "Failed to write to #{path}/#{@word}.mp3!"
    end

    def exist_file?(url)
      # Check if url return a not available audio clip
      Digest::SHA256.hexdigest(url.read) != NOT_AVAILABLE_HASH
    end
  end

  # Handle how input is done arguments or interactive
  #   also deal with other arguments
  class InputHandler
    # NOTE: Change path to fit your system
    def initialize(save_path)
      @save_path = save_path
    end

    def run(args)
      if args.empty?
        # manual_input
        help
      else
        arg_input(args)
      end
    end

    # Display help message for script
    def help
      print "Usage:\npoddl kana [kanji]\n"
      exit 1
    end

    # Argument input.
    def arg_input(args)
      @poddl = Get.new(Word.new(*args))
      @poddl.download(@save_path)
    end

    #    def manual_input
    #      loop do
    #        puts "\nTo quit type quit"
    #        input = [get_input(:kana), get_input(:kanji)]
    #        return 0 if input[0][0].downcase == "q" || input[1][0].downcase == "q"
    #
    #        @poddl.download(@save_path)
    #      end
    #
    #    rescue Interrupt
    #      exit 0
    #    end

    private

    def get_input(name)
      print "Enter #{name}: "
      gets.chomp
    end

    # Assign a new input to poddl and verify.
    def new_input(kana, kanji)
      @poddl.kana = kana
      @poddl.kanji = kanji
    end
  end
end

if $PROGRAM_NAME == __FILE__
  SAVE_PATH = "#{Dir.home}/Documents/Personal/Langauge/Japanese/Audio"

  handler = PODDL::InputHandler.new(SAVE_PATH)
  exit handler.run(ARGV)
end
