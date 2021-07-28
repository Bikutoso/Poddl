# frozen_string_literal: true

require "open-uri"
require "digest"
require_relative "word"

module Poddl
  # Downloads files from languagepod101 with specified kanji/kana
  # @example Simple download
  #   require "poddl"
  #
  #   word = Poddl::Word.new("えき", "駅")
  #
  #   poddl = Poddl::Downloader.new(word)
  #   poddl.download("/tmp")
  class Downloader
    # SHA-256 for a file that's considered empty.
    # @note The actuall file from this hash is an audio clips that says:
    #   <em>"The audio for this clip is currently not available"</em>
    NOT_AVAILABLE_HASH = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906" # SHA-256
    # The URL used to download without the query.
    TARGET_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

    # Initialize instance with specified word.
    #
    # @param word [Poddl::Word] the word to download
    def initialize(word)
      @word = word
    end

    # Starts the download process of the word specified on initialization.
    # @todo Make the parameter an instance variable instead.
    #
    # @param path [String] download directory
    # @return [0, 1] return value
    def download(path)
      unless File.directory?(path)
        warn "#{path} is not a valid directory"
        return 1
      end

      if @word.nil?
        warn "Not a valid word"
        return 1
      end

      url_open(path)
    end

    private

    # Opens the URL before calling {#url_save}.
    # @todo Make it return a <tt>StringIO</tt> object isntead.
    # @todo Make the path parameter an instance variable instead.
    #
    # @param path [String] download directory
    # @return [0,1] return value
    def url_open(path)
      # OPTIMIZE: Store the file in a variable.
      #   It should possibly save a second download? (don't know how rewinds works)
      #   It will also remove the need for the url.rewind.
      #   And make it simpler to check with "file?"

      URI.parse(TARGET_URL + @word.encode).open do |url|
        unless empty_file?(url)
          warn "Unable to find file: #{@word}"
          return 1
        end

        url.rewind
        url_save(url, path)
      end

    rescue SocketError, RuntimeError # Connection? Wrong URL?
      warn "Failed to open #{TARGET_URL}!"
    end

    # Take URI file object and save it to the specified directory
    #
    # @param url [StringIO] URI file object
    # @param path [String] download directory
    # @return [0,1] return value
    def url_save(url, path)
      puts "Downloading: #{@word}"
      File.open("#{path}/#{@word}", "w") do |f|
        # Files are small enough to be saved in one part
        f.write(url.read) ? 0 : 1
      end

    rescue Errno::ENOENT, Errno::EACCES, Errno::EISDIR, Errno::ENOSPC
      warn "Failed to write to #{path}/#{@word}.mp3!"
    end

    # Checks if the SHA256 of the input maches the {NOT_AVAILABLE_HASH}.
    # @note The file is considered empty if it contains an audio clip that says:
    #   <em>"The audio for this clip is currently not available"</em>
    #
    # @param url [StringIO] URI file object
    # @return [Boolean] the result
    def empty_file?(url)
      !!(Digest::SHA256.hexdigest(url.read) != NOT_AVAILABLE_HASH)
    end
  end

  private

  # NOTE: This comment section relates to the Word class in download.rb
  # as i can't make yard stop overriding the class description with these comments
  #
  # Extends poddl/word with #encode
  def dummy; end

  class Word
    # Formats word into URI query.
    #
    # @return [String] the resulting URI query
    def encode
      return if empty?

      # Only encode with kanji when necessary
      if @kanji.nil?
        "?#{URI.encode_www_form([['kana', @kana]])}"
      else
        "?#{URI.encode_www_form([['kana', @kana], ['kanji', @kanji]])}"
      end
    end
  end
end
