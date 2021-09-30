# frozen_string_literal: true

require_relative "lib/poddl/version"

Gem::Specification.new do |s|
  # General
  s.name = "poddl"
  s.version     = Poddl::VERSION
  s.license     = "ISC"
  s.summary     = "Download Japanese audio clips from languagepod101"
  s.author      = "Victoria Solli"
  s.homepage    = "https://github.com/Bikutoso/Poddl/"
  s.description = <<-DEC
  Poddl is a command line program to download Japanese audio clips from languagepod101.
  It can also be used in other projects to store Japanese words or programmatically download files.
  DEC
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0")
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir = "bin"
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
