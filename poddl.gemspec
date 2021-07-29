# frozen_string_literal: true

Gem::Specification.new do |s|
  # General
  s.name        = "poddl"
  s.version     = "1.0.0.dev"
  s.license     = "ISC"
  s.summary     = "Download Japanese audio clips from languagepod101"
  s.description = <<-EOS
  Poddl is a command line program to download Japanese audio clips from languagepod101.
  It can also be used in other projects to store Japanese words or programmatically download files.
  EOS
  s.author      = "Victoria Solli"
  s.homepage    = "https://github.com/Bikutoso/Poddl/"
  # File data
  s.files       = Dir["lib/**/**/*.rb"] + Dir["bin/*"] + Dir["test/*.rb"]
  s.files      += Dir["[A-Z]*"]
  s.executables = "poddl"
  s.test_files  = Dir["test/test*.rb"]
end
