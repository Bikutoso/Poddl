# frozen_string_literal: true

require "open-uri"

module Poddl
  # Word composed of Kanji and Kana
  class Word
    REG_KANA = /\A(?:\p{hiragana}|\p{katakana}|ー)+$\z/.freeze
    REG_KANJI = /\A(?:\p{han}|\p{hiragana})+$\z/.freeze

    attr_reader :kana, :kanji

    # Assign new value to word
    def assign(kana, kanji = nil)
      if !kana.nil? && valid?(kana, REG_KANA) && (kanji.nil? || valid?(kanji, REG_KANJI))
        @kana = kana
        @kanji = kanji
      else
        @kana, @kanji = nil
      end
    end

    def initialize(kana = nil, kanji = nil)
      assign(kana, kanji)
    end

    # Does it contain an empty word?
    def nil?
      # Only kana matters for checking if nil
      @kana.nil?
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
