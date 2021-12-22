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
      # Extend iself with logging?
      # Don't fully understand why this just can't use a simple include.
      extend Logging

      # Expand path to avoid minor path errors like "/tmp//file.mp3"
      full_path = File.expand_path("#{word}.mp3", path)

      logger.info "Saving: #{word}.mp3"

      File.open(full_path, "w") do |f|
        # Files are small enough to be saved in one part
        f.write(data) ? 0 : 1
      end
    rescue Errno::ENOENT, Errno::EACCES, Errno::EISDIR, Errno::ENOSPC
      logger.fatal "Failed to write #{word}.mp3 to #{full_path}!"
    end
  end
end
