#!/usr/bin/env ruby
# frozen_string_literal: true

module Poddl
  # Word composed of Kanji and Kana
  class Word
    attr_reader :kana, :kanji

    # Assign value if input is only kana
    def kana=(kana)
      @kana = kana if valid?(kana, /\A(?:\p{hiragana}|\p{katakana}|ー)+$\z/)
    end

    # Assign value if input is nil or only kanji
    def kanji=(kanji)
      @kanji = kanji if kanji.nil? || valid?(kanji, /\A\p{han}+$\z/)
    end

    def initialize(kana = nil, kanji = nil)
      self.kana = kana
      self.kanji = kanji
    end

    # Returns true if kana & kanji is defined
    def defined?
      # Double negate to return boolean
      !!(defined?(@kana) && defined?(@kanji))
    end

    # Return a formated uri query
    def encode
      # Only encode with kanji when necessary
      if @kanji.nil?
        "?#{URI.encode_www_form([['kana', @kana]])}"
      else
        "?#{URI.encode_www_form([['kana', @kana], ['kanji', @kanji]])}"
      end
    end

    # Formats @kana and @Kanji into simple a usable string
    def to_s
      @kanji.nil? ? "#{@kana}.mp3" : "#{@kanji}_#{@kana}.mp3"
    end

    private

    # Check if string is valid based on Regex
    def valid?(string, regex)
      !!regex.match?(string)
    end
  end
end
