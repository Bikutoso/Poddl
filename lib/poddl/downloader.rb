# frozen_string_literal: true

require "open-uri"
require "digest"
require_relative "word"
require_relative "filer"

module Poddl
  # Downloads files from languagepod101 with specified kanji/kana
  # @example Download a single word
  #   require "poddl"
  #
  #   word = Poddl::Word.new(["えき", "駅"])
  #
  #   Poddl::Downloader.new(Options).download(word, "/tmp")
  # @example Download from gets
  #   require "poddl"
  #
  #   # Create a new instance so it can be used later
  #   #   to download words without creating a new instance each time.
  #   poddl = Poddl::Downloader.new(Options)
  #   input = ""
  #
  #   loop do
  #     printf "Enter input (kana, kanji) :>"
  #     input = gets.chomp.gsub(/\s/, "")
  #
  #     break if input[0].downcase == "q"
  #
  #     # Convert to a two line list split on commas
  #     input = input.split(",")
  #     # Create a word out of the list
  #     word = Poddl::Word.new(input)
  #     # Download the word
  #     poddl.download(word, "/tmp")
  #   end
  class Downloader
    def initialize(options)
      @options = options
    end

    # Starts the download process of the word specified on initialization.
    #
    # @param word [Poddl::Word] download word
    # @param path [String] download directory
    # @return [0, 1] return value
    def download(word, path)
      return 1 unless check_directory(path)
      return 1 unless check_nil(word)

      data = url_open(@options.url, word)

      return 1 unless check_data(data, word)

      Filer.save(data, word, path)
    end

    private

    # Open and read url.
    #
    # @param url [String] url to open
    # @return [String] file data
    def url_open(url, word)
      full_url = url + encode_word(word)

      puts "Downloading: #{word}.mp3"

      URI.parse(full_url).open.read

    # FIXME: Getting "uninitialized constant" on error class?
    rescue SocketError, RuntimeError # Connection? Wrong URL?
      warn "Failed to open #{@options.url}!"
    end

    # Formats a Word into URI query.
    #
    # @param word [#to_a] selected word
    # @return [String] the resulting URI query
    def encode_word(word)
      return unless word.respond_to?("to_a")

      wlst = word.to_a.first(2)
      return if wlst.empty?

      # Only encode with kanji when necessary
      if wlst[1].nil?
        "?#{URI.encode_www_form([['kana', wlst[0]]])}"
      else
        "?#{URI.encode_www_form([['kana', wlst[0]], ['kanji', wlst[1]]])}"
      end
    end

    # Checks and prints error if word is nil.
    #
    # @param word [Poddl::Word] checked word
    # @return [Boolean] return value
    def check_nil(word)
      return true unless word.nil?

      !!(warn "Not a valid word")
    end

    # Checks and prints error if directory does not exist.
    #
    # @param path [String] cheked path
    # @return [Boolean] return value
    def check_directory(path)
      return true if File.directory?(path)

      !!(warn "#{path} is not a valid directory")
    end

    # Checks and prints error if the data is invalid.
    #
    # @param data [String] data to check
    # @param word [String] used in error printing
    # @return [Boolean] return value
    def check_data(data, word)
      return true unless
          Digest::SHA256.hexdigest(data) == @options.url_hash

      !!(warn "Unable to find file: #{word}.mp3")
    end
  end
end
