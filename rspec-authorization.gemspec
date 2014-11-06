lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/authorization/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-authorization"
  spec.version       = RSpec::Authorization::VERSION
  spec.authors       = ["Hendra Uzia"]
  spec.email         = ["hendra.uzia@gmail.com"]
  spec.summary       = %q{RSpec matcher for declarative_authorization.}
  spec.description   = %q{A neat way of asserting declarative_authorization's rules inside controller using RSpec matcher.}
  spec.homepage      = "https://github.com/hendrauzia/rspec-authorization"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "declarative_authorization"
  spec.add_runtime_dependency "rails", "~> 4.0"
  spec.add_runtime_dependency "rspec-rails", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "sqlite3"
end
