# frozen_string_literal: true

require "open-uri"

module Poddl
  # Word composed of Kanji and Kana
  class Word
    attr_reader :kana, :kanji

    # Create a new Japanese word contaning kana (and kanji)
    def initialize(kana, kanji = nil)
      reg_kana = /\A(?:\p{hiragana}|\p{katakana}|ー)+$\z/.freeze
      reg_kanji = /\A(?:\p{han}|\p{hiragana})+$\z/.freeze

      # Assign variables only if kana and kanji is valid.
      #   Othervise assign both to nil
      if valid?(kana, reg_kana) && (kanji.nil? || valid?(kanji, reg_kanji))
        @kana = kana
        @kanji = kanji
      else
        @kana, @kanji = nil
      end
    end

    # Is the instance empty?
    def empty?
      @kana.nil?
    end

    # Encodes word with 
    # {URI#encode_www_form}[https://ruby-doc.org/stdlib/libdoc/uri/rdoc/URI.html#method-c-encode_www_form]
    # encoded form string
    def encode
      return if empty?

      # Only encode with kanji when necessary
      if @kanji.nil?
        "?#{URI.encode_www_form([['kana', @kana]])}"
      else
        "?#{URI.encode_www_form([['kana', @kana], ['kanji', @kanji]])}"
      end
    end

    # Formats @kana and @Kanji into simple a usable string
    def to_s
      return if empty?

      @kanji.nil? ? "#{@kana}.mp3" : "#{@kanji}_#{@kana}.mp3"
    end

    # Is the instance nil?
    alias nil? empty?

    private

    # Check if string is valid based on Regex
    def valid?(string, regex)
      !!regex.match?(string)
    end
  end
end
