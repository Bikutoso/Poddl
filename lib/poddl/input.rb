# frozen_string_literal: true
# Gender love, not hate

require_relative "downloader"

module Poddl
  # Runs the program with the selected input handler
  module Input
  end
end

require_relative "input/cli"
require_relative "input/interactive"
require_relative "input/file"
