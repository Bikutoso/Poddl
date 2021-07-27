Gem::Specification.new do |s|
  # General
  s.name        = "poddl"
  s.version     = "1.0.0.dev"
  s.license = "ISC"
  s.summary     = "Download Japanese audio clips from languagepod101"
  s.description = "" # TODO: Write this.
  s.author      = "Victoria Solli"
  s.homepage    = "https://github.com/Bikutoso/Poddl/"
  # File data
  s.files       = Dir["lib/**/**/*.rb"] + Dir["bin/*"] + Dir["test/*.rb"]
  s.files      += Dir["[A-Z]*"]
  s.executables = "poddl"
  s.test_files  = Dir["test/test*.rb"]
  # Dependencies
  s.add_development_dependency "shoulda", "~> 4.0", ">= 4.0.0"
  ## These should be installed by default. But includes just in case.
  s.add_runtime_dependency "digest", "~> 3.0", ">= 3.0.0"
  s.add_runtime_dependency "open-uri", "~> 0.1", ">= 0.1.0"
  s.add_runtime_dependency "optparse", "~> 0.1", ">= 0.1.0"
end
