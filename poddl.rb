#!/usr/bin/env ruby

require "open-uri"
require "digest"

class Poddl
  @@NOFILE = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906" # sha256 of file that does not exists
  @@TARGET_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

  def initialize( kana, kanji=nil )
    @kana = kana

    if kanji.nil? # Assign kana to @kanji if kanji is nil
      @kanji = kana
    else
      @kanji = kanji
    end
  end
  
  def download( path )
    URI.open(@@TARGET_URL + "?" + self.encode_uri) do |url|
      if Digest::SHA256.hexdigest(url.read) != @@NOFILE # Is invalid?
        url.rewind
        puts "Downloading: #{@kanji}「#{@kana}」"
        File.open( "#{path}/#{@kanji}_#{@kana}.mp3", "w") do |f|
          f.write(url.read) # Files are small enough to be saved without using segments
        end
      else
        puts "#{@kanji}「#{@kana}」 not valid"
      end
    end
  end

  private
  def encode_uri
    # Returns a formated uri query string
    return "?" + URI.encode_www_form([["kanji", @kanji], ["kana", @kana]])
  end
end

if $0 == __FILE__
  SAVE_PATH = "#{Dir.home}/Documents/Personal/Langauge/Japanese/Audio" # Where to save the file
  poddl = Poddl.new(ARGV[0], ARGV[1])
  poddl.download(SAVE_PATH)
end