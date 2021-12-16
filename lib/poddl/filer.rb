# frozen_string_literal: true

require_relative "logger"

module Poddl
  # Class related to storing files
  class Filer
    # Save data to specified file.
    #
    # @param data [String] data file
    # @param word [String] file name
    # @param path [String] download directory
    # @return [Boolean] return value
    def self.save(data, word, path)
      # Expand path to avoid minor path errors like "/tmp//file.mp3"
      full_path = File.expand_path("#{word}.mp3", path)

      Poddl::Logger.verbose "Saving: #{word}.mp3"

      File.open(full_path, "w") do |f|
        # Files are small enough to be saved in one part
        f.write(data) ? 0 : 1
      end
    rescue Errno::ENOENT, Errno::EACCES, Errno::EISDIR, Errno::ENOSPC
      Poddl::Logger.error "Failed to write #{word}.mp3 to #{full_path}!"
    end
  end
end
