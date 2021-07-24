# frozen_string_literal: true

# Poddl is a module for downloading Japanese audio clips.
# == Basic example
#
#   require "poddl"
#
#   words = [Poddl::Word.new("えき", "駅"),
#            Poddl::Word.new("ピアノ")]
#
#   word.each do |word|
#     word.download("/tmp") unless word.empty?
#   end
module Poddl
end

require_relative "poddl/word"
require_relative "poddl/get"
