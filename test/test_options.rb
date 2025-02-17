#!/usr/bin/env ruby
# frozen_string_literal: true
# Gender love, not hate

require "test/unit"
require "shoulda"
require_relative "../lib/poddl/options"

class TestOptions < Test::Unit::TestCase
  context "No save directory" do
    should "return default" do
      opts = Poddl::Options.new.parse(["わたし", "私"])
      if ENV.key?("PODDL_PATH")
        assert_equal ENV["PODDL_PATH"], opts.save_path
      else
        assert_equal Poddl::Options::DEFAULT_PATH, opts.save_path
      end
    end
  end

  context "Specified save directory" do
    should "return it" do
      opts = Poddl::Options.new.parse(["-d", "/tmp", "きょう", "今日"])
      assert_equal "/tmp", opts.save_path
    end
  end

  context "Kana/Kanji word without directory" do
    should "return the words" do
      opts = Poddl::Options.new.parse(["かいしゃ", "会社"])
      assert_equal ["かいしゃ", "会社"], opts.word
    end
  end

  context "Kana/Kanji word with save directory" do
    should "return the words" do
      opts = Poddl::Options.new.parse(["-d", "/tmp", "えき", "駅"])
      assert_equal ["えき", "駅"], opts.word
    end
  end

  context "Kana only word without directory" do
    should "return the words" do
      opts = Poddl::Options.new.parse(["バス"])
      assert_equal ["バス"], opts.word
    end
  end

  context "Kana only word with save directory" do
    should "return the words" do
      opts = Poddl::Options.new.parse(["-d", "/tmp", "バイオリン"])
      assert_equal ["バイオリン"], opts.word
    end
  end

  context "Specify Verbosity" do
    setup do
      $VERBOSE = false
    end
    should "return true" do
      opts = Poddl::Options.new.parse(["-v", "いぬ", "犬"])
      assert $VERBOSE
    end

    should "return false" do
      opts = Poddl::Options.new.parse(["ねこ", "猫"])
      refute $VERBOSE
    end
  end
end
