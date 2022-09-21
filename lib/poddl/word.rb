# frozen_string_literal: true

module Poddl
  # Defines a Japanese word.
  #
  # @example An array of words
  #  require "poddl/word"
  #
  #  input = [["えき","駅"], ["きく", "聞く"], ["パン"]]
  #
  #  words = []
  #
  #  input.each do |word|
  #    words.append(Poddl::Word.new(word))
  #  end
  class Word
    # @return [String]
    attr_reader :kana, :kanji

    # Create new word from parameters
    #
    # @param word [Array<String, String>] kanji and hiragana
    def initialize(word)
      # Assign variables only if kana and kanji is valid.
      #   Othervise assign both to nil
      if valid?(*word)
        @kana, @kanji = word
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
    # @note String is formated as kanji followed by kana.
    #   E.g. <tt>駅_えき</tt>
    #
    # @return [String] the resulting string
    def to_s
      return if empty?

      @kanji.nil? ? @kana.to_s : "#{@kanji}_#{@kana}"
    end

    # Formats Word into an array. Returns empty array in invalid word.
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
    # @param kanji [String, nil] string of kanji to check
    # @return [Boolean] is it a valid word?
    def valid?(kana, kanji = nil, *_)
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
