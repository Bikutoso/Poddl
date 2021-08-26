# frozen_string_literal: true

module Poddl
  module Input
    # Common objects in the {Poddl::Input} module
    module Common
      # Calls {Poddl::Downloader#download}
      # with the save path specified in the options
      #
      # @param word [Poddl::Word] word object
      # @return [0,1] return value
      def get(word, poddl = Poddl::Downloader.new)
        poddl.download(word, @options.save_path)
      end
    end
  end
end
