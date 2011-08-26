Gem::Specification.new do |s|
  s.name              = "sequel-fusiontables"
  s.version           = "0.0.2"
  s.summary           = "Fusion Tables adapter for Sequel"
  s.authors           = ["Damian Janowski"]
  s.email             = ["djanowski@dimaion.com"]
  s.homepage          = "http://github.com/djanowski/sequel-fusiontables"

  s.add_dependency("ft", ">= 0.0.2")
  s.add_dependency("sequel")

  s.files = Dir[
    "*.gemspec",
    "*LICENSE",
    "README*",
    "Rakefile",
    "bin/*",
    "lib/**/*",
    "test/**/*",
  ]
end
