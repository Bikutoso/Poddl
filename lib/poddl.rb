# frozen_string_literal: true

# Poddl is a module for downloading Japanese audio clips.
# @example Download a list of {Poddl::Word}s
#   require "poddl"
#
#   words = [Poddl::Word.new("えき", "駅"),
#            Poddl::Word.new("ピアノ")]
#
#   word.each do |word|
#     next if word.empty?
#
#     poddl = Poddl::Downloader.new(word)
#     poddl.download("/tmp")
#   end
module Poddl
end

require_relative "poddl/word"
require_relative "poddl/get"
