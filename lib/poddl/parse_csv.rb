# frozen_string_literal: true

require "csv"

require_relative "logger"
require_relative "word"

module Poddl
  # Parses CSV files into words
  class ParseCSV
    def self.parse(path)
      extend Logging

      words = []
      CSV.read(path).each do |word|
        words.append(Poddl::Word.new(word))
        logger.debug "Generated word:#{word}, #{words[-1]}"
      end
      words
    end
  end
end
