Gem::Specification.new do |s|
  s.name        = "poddl"
  s.summary     = "Download Japanese audio clips from languagepod101"
  s.description = ""
  s.version     = "0.1"
  s.licenses    = ["ISC"]
  s.author      = "Victoria Solli"
  s.homepage    = "https://github.com/Bikutoso"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = ">=2.7"
  s.files       = Dir["**/**"]
  s.executables = ["poddl"]
  s.test_files  = Dir["test/test*.rb"]
end
