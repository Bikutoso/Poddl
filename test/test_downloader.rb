#!/usr/bin/env ruby
# frozen_string_literal: true

require "test/unit"
require "shoulda"
require_relative "../lib/poddl/downloader"

# Tests for Poddl::Downloader class
class DownloadTest < Test::Unit::TestCase
  context "Handle correct data" do
    setup do
      @dw = Poddl::Downloader.new
      @valid_words = [["でんしゃ", "電車"], # Kana/Kanji
                      ["いそぐ", "急ぐ"],   # Kanji with hiragana
                      ["カメラ", nil],      # Katakana only
                      ["どうやって", nil]]  # Hiragana only
    end

    should "Encode correctly" do
      @valid_words.each do |word|
        regex = /\A\?kana=(%\X\X)*(&kanji=(%\X\X)*)?$\z/
        
        # Poddl:Downloader#encode_word is a private method but should be tested.
        assert_match regex, @dw.send(:encode_word, word)
      end
    end
  end
end
