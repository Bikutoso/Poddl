#!/usr/bin/env ruby
# frozen_string_literal: true

require "test/unit"
require "shoulda"
require_relative "../lib/poddl/downloader"

# Options to use during test
class Options
  def initialize
    self.url = "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php"
    self.url_hash = "ae6398b5a27bc8c0a771df6c907ade794be15518174773c58c7c7ddd17098906"
  end
end

# Tests for Poddl::Downloader class
class DownloadTest < Test::Unit::TestCase
  context "Handle correct data" do
    setup do
      @dw = Poddl::Downloader.new(Options)
      @valid_words = [["でんしゃ", "電車"], # Kana/Kanji
                      ["いそぐ", "急ぐ"],   # Kanji with hiragana
                      ["カメラ", nil],      # Katakana only
                      ["どうやって", nil]]  # Hiragana only
    end

    should "encode correctly" do
      @valid_words.each do |word|
        regex = /\A\?kana=(%\X\X)*(&kanji=(%\X\X)*)?$\z/
        
        # Poddl:Downloader#encode_word is a private method but should be tested.
        assert_match regex, @dw.send(:encode_word, word)
      end
    end
  end
end
