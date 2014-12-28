# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "simple_orm"
  spec.version       = "0.0.1" #SimpleORM::VERSION
  spec.authors       = ["Denis D., Chimit N."]
  spec.email         = ["laba2_level_project@gmail.com"]
  spec.summary       = %q{Provides ActiveRecord-like generic, core functionalities.}
  spec.description   = %q{Provides ActiveRecord-like general functionalities, particularly DB access and defining relalations between models.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"         # 1.6.2
  spec.add_development_dependency "rake", "~> 10.3"           # 10.3.2
  
  spec.add_development_dependency "sqlite3", "~> 1.3.10"      # 1.3.10

  spec.add_runtime_dependency "pry", "~> 0.10"                # 0.10.1
  spec.add_runtime_dependency "rspec", "~> 3.1.0"             # 3.1.0
  spec.add_runtime_dependency "nokogiri", "~> 1.6.3"          # 1.6.3.1
end
