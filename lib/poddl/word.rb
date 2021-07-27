# frozen_string_literal: true

require "open-uri"

module Poddl
  # Defines a Japanese word.
  #
  # == Example
  #   require "poddl/word"
  #
  #   class Someclass
  #     attr_accessor :words
  #
  #     def initialize
  #       @words = []
  #     end
  #
  #     def add_word(kana, kanji = nil)
  #       @words.append(Poddl::Word.new(kana, kanji)
  #     end
  #   end
  class Word

    # @return [String]
    attr_reader :kana, :kanji

    # Create new word from parameters
    # 
    # @param kana [String] hiragana or katakana
    # @param kanji [String, nil] kanji and hiragana or nil
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

    # Returns boolean based on if instance is considered empty.
    # 
    # @return [Boolean] the resulting boolean
    def empty?
      @kana.nil?
    end

    # Formats word into URI query.
    #
    # @return [String] the resulting URI query
    def encode
      return if empty?

      # Only encode with kanji when necessary
      if @kanji.nil?
        "?#{URI.encode_www_form([['kana', @kana]])}"
      else
        "?#{URI.encode_www_form([['kana', @kana], ['kanji', @kanji]])}"
      end
    end

    # Formats Word into string.
    # @note String is formated into a filename with the mp3 file extension.
    #   E.g. <tt>駅_えき.mp3</tt>
    # 
    # @return [String] the resulting string
    def to_s
      return if empty?

      @kanji.nil? ? "#{@kana}.mp3" : "#{@kanji}_#{@kana}.mp3"
    end

    # Is the instance nil?
    alias nil? empty?

    private

    # Maches a string with a regex expression.
    #
    # @param string [String] string to compare
    # @param regex  [Regexp] regex to compare
    # @return [Boolean] the result of the match
    def valid?(string, regex)
      !!regex.match?(string)
    end
  end
end
