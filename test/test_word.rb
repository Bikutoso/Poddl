#!/usr/bin/env ruby
# frozen_string_literal: true

require "test/unit"
require_relative "../lib/poddl/word"

# Word should handle a Japanese word
class TestWord < Test::Unit::TestCase
  REG_KANA = /\A(?:\p{hiragana}|\p{katakana}|ー)+$\z/.freeze
  REG_KANJI = /\A(?:\p{han}|\p{hiragana})+$\z/.freeze

  # Test if the value if kana/kanji is correct
  def test_value_valid
    tw = Poddl::Word.new("きょう", "今日")
    assert_equal("きょう", tw.kana, "Kana is not assigned")
    assert_match(REG_KANA, tw.kana, "Kana is not kana")

    assert_equal("今日", tw.kanji, "Kanji is not assigned")
    assert_match(REG_KANJI, tw.kanji, "Kanji is not kanji")
  end

  # Test that value is not assigned if wrong
  def test_value_wrong
    tw = Poddl::Word.new("わwした", "話f派")
    assert_nil(tw.kana, "Kana should have value of nil")
    refute_match(REG_KANA, tw.kana, "Kana is kana")

    assert_nil(tw.kanji, "Kanji should have value of nil")
    refute_match(REG_KANJI, tw.kanji, "Kanji is Kanji")
  end

  # Test if it gets correct value if reassigned
  def test_reassing
    wordlist = [["きせつ", "季節"], ["コンビニ", nil],
                ["てんき", "電気"], ["いそぐ", "急ぐ"],
                ["びょうき", "病気"], ["ギター", nil]]

    wordlist.each do |word|
      tw = Poddl::Word.new(*word)
      assert_equal(word[0], tw.kana, "Kana is #{tw.kana} but expected #{word[0]}")
      assert_equal(word[1], tw.kanji, "Kanji is #{tw.kanji} but expected #{word[0]}")
    end
  end

  # Does it encode into URI query?
  def test_uri_string
    tw = Poddl::Word.new("でんしゃ", "電車")
    assert_equal("?kana=%E3%81%A7%E3%82%93%E3%81%97%E3%82%83&kanji=%E9%9B%BB%E8%BB%8A",
                 tw.encode, "Kana/Kanji encoding misformed")

    tw = Poddl::Word.new("バソコン", nil)
    assert_equal("?kana=%E3%83%90%E3%82%BD%E3%82%B3%E3%83%B3",
                 tw.encode, "Kana only encoding misformed")
  end

  # Does it reteurn apropriate to_s?
  def test_to_s
    tw = Poddl::Word.new("あめ", "雨")
    assert_equal("雨_あめ.mp3", tw.to_s, "Misformed kana/kanji string")

    tw = Poddl::Word.new("カメラ", nil)
    assert_equal("カメラ.mp3", tw.to_s, "Misformed kana only string")
  end
end
