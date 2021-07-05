#!/usr/bin/env ruby

require "open-uri"
require "digest"

class Poddl
  @@NOT_AVAILABLE_HASH = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906" # sha256 of file that does not exists
  @@TARGET_URL = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"

  attr_reader :kana
  attr_reader :kanji
  
  def initialize( kana, kanji=nil )
    @kana = kana
    @kanji = kanji
  end

  def remap( kana, kanji=nil )
    # Easier than changing it through attr_writer
    self.initialize( kana, kanji )
    return 1
  end
  
  def download( path )
    # Downloads audio file to specified path
    if not File.directory?(path)
      puts "@{path} is not a valid directory"
      return 1
    end
    begin
      URI.open(@@TARGET_URL +  encode_uri) do |url|
        if Digest::SHA256.hexdigest(url.read) != @@NOT_AVAILABLE_HASH # Check if url return a not available audio clip
          url.rewind # Rewind after SHA256
          puts "Downloading: #{pretty_name(:file)}.mp3"
          File.open( "#{path}/#{pretty_name(:file)}.mp3", "w") do |f|
            f.write(url.read) # Files are small enough to be saved in one part
          end
          return 0 # Success
        else
          puts "#{pretty_name} not valid"
          return 1 # Failure
        end
      end
    rescue SocketError, RuntimeError # Some sort of network error. Lost connection? Wrong URL?
      puts "Network Error"
      exit 1
    end
  end

  private
  def encode_uri
    # Returns a formated uri query string
    if @kanji.nil? # Only encode with kanji when necessary
        return "?" + URI.encode_www_form([["kana", @kana]])
      else
        return "?" + URI.encode_www_form([["kana", @kana], ["kanji", @kanji]])
      end
  end

  def pretty_name( file=nil )
    # Formats @kana,@kanji into a pretty format
    if file == :file
      return @kanji.nil? ? "#{@kana}" : "#{@kanji}_#{@kana}" # format for filename
    else
      return @kanji.nil? ? "#{@kana}" : "#{@kanji} 「#{@kana}」" # format for printing
    end
  end
end

if $0 == __FILE__
  SAVE_PATH = "#{Dir.home}/Documents/Personal/Langauge/Japanese/Audio" # Location to save file
  status = 0
  if not ARGV.empty?
    poddl = Poddl.new(ARGV[0], ARGV[1])
    status = poddl.download(SAVE_PATH)
  else
    print "Usage:\npoddl kana [kanji]\n"
    status = 1
  end

  if status == 0
    exit 0
  else
    exit 1
  end
end