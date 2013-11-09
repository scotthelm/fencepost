$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fencepost/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fencepost"
  s.version     = Fencepost::VERSION
  s.license     = "MIT"
  s.authors     = ["Scott Helm"]
  s.email       = ["helm.scott@gmail.com"]
  s.homepage    = "https://github.com/scotthelm/fencepost"
  s.summary     = "Rails 4.x strong parameter configuration for your AR models"
  s.description = "Dynamic strong parameter configuration for your AR models"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "pry-plus"

end
