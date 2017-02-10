# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/aws_black_belt/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-aws_black_belt"
  spec.license       = "MIT"
  spec.version       = Ruboty::AwsBlackBelt::VERSION
  spec.authors       = ["koshigoe"]
  spec.email         = ["koshigoeb@gmail.com"]

  spec.summary       = %q{Ruboty plugin for AWS Black Belt online seminar.}
  spec.description   = %q{Ruboty plugin for AWS Black Belt online seminar.}
  spec.homepage      = "https://github.com/koshigoe/ruboty-aws_black_belt"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.3.2"

  spec.add_dependency "ruboty", "~> 1.3.0"
  spec.add_dependency "nokogiri", "~> 1.7.0.1"
  spec.add_dependency "mechanize", "~> 2.7.5"
end
