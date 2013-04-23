$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "crimagify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "crimagify"
  s.version     = Crimagify::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Crimagify."
  s.description = "TODO: Description of Crimagify."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency "rmagick", "~> 2.13.1"
  s.add_dependency "carrierwave", "~> 0.8.0"
  s.add_dependency "sass-rails"#, "~> 0.8.0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
