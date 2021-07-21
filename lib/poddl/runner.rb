#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "word"
require_relative "get"
require_relative "options"

module Poddl
  class Runner
    def initialize(argv)
      @poddl = Poddl::Get.new
      @options = Options.new(argv)
    end

    def run
      # NOTE: Only supports command line input in the begining
      @poddl.word = Poddl::Word.new(*@options.word)
      @poddl.download(@options.save_path)
    end
  end
end
