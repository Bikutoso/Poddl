# frozen_string_literal: true

require_relative "../word"
require_relative "../logger"
require_relative "common"

module Poddl
  module Input
    # @todo Create class
    class Interactive
      include Poddl::Input::Common

      # Initialize instance with specified arguemtn options
      # 
      # @param options [Poddl::Options] parsed optparse object
      def initialize(options)
        @options = options
      end

      # Query use for word then calls {Poddl::Input::Handler#get} on it.
      #
      # @return [Boolean] return value
      # @see Poddl::Input::Handler#run
      def run
        Poddl::Logger.verbose "Interactive mode"
        printf "Enter kana: "
        kana = gets.chomp
        printf "Enter kanji: \e[36;2;3mnil\b\b\b\e[0m" # FIXME: Back charachter to long
        kanji = gets.chomp
        
        kanji = nil if kanji.empty?

        word = Poddl::Word.new([kana, kanji])
        get(word)
      end
    end
  end
end
