# frozen_string_literal: true

require "open-uri"
require "digest"
require_relative "word"

module Poddl
  # Downloads files from languagepod101 with specified kanji/kana
  # @example Download a single word
  #   require "poddl"
  #
  #   word = Poddl::Word.new(["えき", "駅"])
  #
  #   Poddl::Downloader.new.download(word, "/tmp")
  # @example Download from gets
  #   require "poddl"
  #
  #   # Create a new instance so it can be used later
  #   #   to download words without creating a new instance each time.
  #   poddl = Poddl::Downloader.new
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
    # SHA-256 for a file that's considered empty.
    # @note The actuall file from this hash is an audio clips that says:
    #   <em>"The audio for this clip is currently not available"</em>
    NOT_AVAILABLE_HASH = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906"
    # The URL used to download without the query.
    TARGET_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

    # Starts the download process of the word specified on initialization.
    #
    # @param word [Poddl::Word] download word
    # @param path [String] download directory
    # @return [0, 1] return value
    def download(word, path)
      return 1 unless check_directory(path)
      return 1 unless check_nil(word)

      data = url_open(TARGET_URL + encode_word(word))

      return 1 unless check_data(data, word)

      puts "Downloaded: #{word}.mp3"
      url_save(data, "#{path}/#{word}.mp3")
    end

    private

    # Open and read url.
    #
    # @param url  [String] url to open
    # @return [String] file data
    def url_open(url)
      URI.parse(url).open.read
    rescue SocketError, RuntimeError # Connection? Wrong URL?
      warn "Failed to open #{TARGET_URL}!"
    end

    # Save data to specified file.
    #
    # @param data [String] data file
    # @param path [String] download directory
    # @return [0,1] return value
    def url_save(data, path)
      File.open(path, "w") do |f|
        # Files are small enough to be saved in one part
        f.write(data) ? 0 : 1
      end
    rescue Errno::ENOENT, Errno::EACCES, Errno::EISDIR, Errno::ENOSPC
      warn "Failed to write to #{path}!"
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
      return true unless empty_file?(data)

      !!(warn "Unable to find file: #{word}.mp3")
    end

    # Checks if the SHA256 of the input maches the {NOT_AVAILABLE_HASH}.
    # @note The file is considered empty if it contains an audio clip that says:
    #   <em>"The audio for this clip is currently not available"</em>
    #
    # @param data [String] data file
    # @return [Boolean] the result
    def empty_file?(data)
      !!(Digest::SHA256.hexdigest(data) == NOT_AVAILABLE_HASH)
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
  end
end
