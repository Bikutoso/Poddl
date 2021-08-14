# frozen_string_literal: true

module Poddl
  # Defines a Japanese word.
  #
  # @example A class that stores Words
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
  #       @words.append(Poddl::Word.new(kana, kanji))
  #     end
  #   end
  class Word
    # @return [String]
    attr_reader :kana, :kanji

    # Create new word from parameters
    #
    # @param kana [String] hiragana or katakana
    # @param kanji [String, nil] kanji and hiragana or nil
    def initialize(kana, kanji = nil, *_)
      # Assign variables only if kana and kanji is valid.
      #   Othervise assign both to nil
      if valid?(kana, kanji)
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

    # Formats Word into string.
    # @note String is formated into a filename with the mp3 file extension.
    #   E.g. <tt>駅_えき.mp3</tt>
    #
    # @return [String] the resulting string
    def to_s
      return if empty?

      @kanji.nil? ? @kana.to_s : "#{@kanji}_#{@kana}"
    end

    # Formats Word into an array
    #
    # @return [Array<String, String>, Array<>] a list contaning kana and kanji
    def to_a
      empty? ? [] : [@kana, @kanji]
    end

    # Is the instance nil?
    alias nil? empty?

    private

    # Checks if it's a valid word
    #
    # @param kana [String] string of kana to check
    # @param kanji [String] string of kanji to check
    # @return [Boolean] is it a valid word?
    def valid?(kana, kanji)
      reg_kana = /\A(\p{hiragana}|\p{katakana}|ー)+$\z/.freeze
      reg_kanji = /\A(\p{han}|\p{hiragana})+$\z/.freeze

      regex_match?(kana, reg_kana) &&
        (kanji.nil? || regex_match?(kanji, reg_kanji))
    end

    # Maches a string with a regex expression.
    #
    # @param string [String] string to compare
    # @param regex  [Regexp] regex to compare
    # @return [Boolean] the result of the match
    def regex_match?(string, regex)
      !!regex.match?(string)
    end
  end
end
