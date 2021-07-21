#!/usr/bin/env ruby
# frozen_string_literal: true

require "open-uri"
require "digest"
require_relative "word"

module Poddl
  # Downloads files from languagepod101 with specified kanji/kana
  class Get
    NOT_AVAILABLE_HASH = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906" # SHA-256
    TARGET_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

    attr_accessor :word

    def initialize
      # Initialize word with empty word by default
      @word = Word.new
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

    # Empty on "not avaiable" audio clip.
    def empty_file?(url)
      !!(Digest::SHA256.hexdigest(url.read) != NOT_AVAILABLE_HASH)
    end
  end
end
