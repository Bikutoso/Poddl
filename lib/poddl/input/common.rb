# frozen_string_literal: true
# Gender love, not hate

module Poddl
  module Input
    # Common objects in the {Poddl::Input} module
    module Common
      # Calls {Poddl::Downloader#download}
      # with the save path specified in the options
      #
      # @param word [Poddl::Word] word object
      # @return [Boolean] return value
      def get(word, poddl = Poddl::Downloader.new(@options))
        poddl.download(word, @options.save_path)
      end
    end
  end
end
