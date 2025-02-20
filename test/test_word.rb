#!/usr/bin/env ruby
# frozen_string_literal: true
# Gender love, not hate

require "test/unit"
require "shoulda"
require_relative "../lib/poddl/word"

# Tests if Word class preforms as expected
class WordTest < Test::Unit::TestCase
  context "Handle correct data" do
    setup do
      @valid_words = [["でんしゃ", "電車"], # Kana/Kanji
                      ["いそぐ", "急ぐ"],   # Kanji with hiragana
                      ["カメラ", nil],      # Katakana only
                      ["どうやって"],       # Hiragana only
                      ["えき", "駅", "エキ"]]  # More items in array
    end

    should "not be empty" do
      @valid_words.each do |word|
        refute_empty Poddl::Word.new(word)
      end
    end

    should "assign correctly" do
      @valid_words.each do |word|
        tw = Poddl::Word.new(word)
        assert_equal [word[0],word[1]], [tw.kana, tw.kanji]
      end
    end

    should "display to_s correctly" do
      @valid_words.each do |word|
        tw = Poddl::Word.new(word)
        compare_string = %(#{"#{tw.kanji}_" if tw.kanji}#{tw.kana})
        assert_equal compare_string, tw.to_s
      end
    end

    should "return array on to_a" do
      @valid_words.each do |word|
        tw = Poddl::Word.new(word)
        assert_equal [word[0], word[1]], tw.to_a
      end
    end
  end

  context "Handle invalid data" do
    setup do
      @invalid_words = [["wでんしゃ", "電車"], # Kana
                        ["かいしゃ", "会社3"], # Kanji
                        ["いそぐ", "急ぐ@"],   # Kanji with hiragana
                        ["¥スキー", nil],      # Katakana only
                        ["どうやってw", nil],  # Hiragana only
                        [nil, "明日"],         # Kanji only
                        ["今朝", "けさ"],      # Swapped
                        [nil, nil]]            # nil
    end

    should "be empty" do
      @invalid_words.each do |word|
        assert_empty Poddl::Word.new(word)
      end
    end

    should "return nil on to_s" do
      @invalid_words.each do |word|
        refute Poddl::Word.new(word).to_s
      end
    end

    should "return empty array on invalid to_a" do
      @invalid_words.each do |word|
        assert Poddl::Word.new(word).to_a.empty?
      end
    end
  end
end
