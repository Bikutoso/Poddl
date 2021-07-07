#!/usr/bin/env ruby
# frozen_string_literal: true

require "open-uri"
require "digest"

# Downloads files from languagepod101 with specified kanji/kana
class Poddl
  NOT_AVAILABLE_HASH = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906" # SHA-256
  TARGET_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

  attr_accessor :kana, :kanji

  def initialize(kana, kanji = nil)
    if kana.match?(/^(?:\p{hiragana}|\p{katakana}|ー)+$/) # kana?
      @kana = kana
    else
      warn "\"#{kana}\" is not valid kana"
      exit 1 # Can't return here?
    end

    if kanji.nil? || kanji.match?(/^\p{han}+$/) # nil or kanji?
      @kanji = kanji
    else
      warn "\"#{kanji}\" is not valid kanji"
      exit 1 # Can't return here?
    end
  end

  # Downloads audio file to the specified path
  def download(path)
    unless File.directory?(path)
      warn "#{path} is not a valid directory"
      return 1
    end

    URI.parse(TARGET_URL + encode_uri).open do |url|
      # Check if url return a not available audio clip
      if Digest::SHA256.hexdigest(url.read) != NOT_AVAILABLE_HASH
        url.rewind

        puts "Downloading: #{pretty_name(file: true)}.mp3"
        File.open("#{path}/#{pretty_name(file: true)}.mp3", "w") do |f|
          # Files are small enough to be saved in one part
          f.write(url.read)
        end
        return 0
      else
        warn "#{pretty_name} not valid"
        warn "Kanji might be required even if it's not in common use" if @kanji.nil?
        return 1
      end
    end
  rescue SocketError, RuntimeError # Connection? Wrong URL?
    warn "Network Error"
    exit 1
  end

  private

  # Return a formated uri query
  def encode_uri
    # Only encode with kanji when necessary
    if @kanji.nil?
      "? #{URI.encode_www_form([['kana', @kana]])}"
    else
      "? #{URI.encode_www_form([['kana', @kana], ['kanji', @kanji]])}"
    end
  end

  # Formats @kana and @Kanji into simple a pretty string
  def pretty_name(file: false)
    if file
      @kanji.nil? ? @kana.to_s : "#{@kanji}_#{@kana}" # filename
    else
      @kanji.nil? ? @kana.to_s : "#{@kanji} 「#{@kana}」" # printing
    end
  end
end

if $PROGRAM_NAME == __FILE__

  # NOTE: Change path to fit your system
  SAVE_PATH = "#{Dir.home}/Documents/Personal/Langauge/Japanese/Audio"

  if ARGV.empty?
    print "Usage:\npoddl kana [kanji]\n"
    exit 1
  else
    poddl = Poddl.new(ARGV[0], ARGV[1])
    exit poddl.download(SAVE_PATH)
  end
end
