# frozen_string_literal: true
# Gender love, not hate

require "logger"

# Mixin module for logging
module Logging
  # @todo Figure out what this does
  def logger
    Logging.logger
  end

  # This initializes the logger and formats it based on options.
  # @todo ditto
  def self.logger
    @logger ||= Logger.new($stdout)

    # Set log level and format based on verbosity
    if $VERBOSE || $DEBUG
      @logger.level = $DEBUG ? :debug : :info
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        "[#{severity}] #{datetime.strftime('%Y-%m-%d %H:%M:%S')}: #{msg}\n"
      end
    else
      @logger.level = :warn
      @logger.formatter = proc do |_severity, _datetime, _progname, msg|
        "#{msg}\n"
      end
    end

    @logger
  end
end
