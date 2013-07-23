# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gh_repo_stats/version'

Gem::Specification.new do |spec|
  spec.name          = "gh_repo_stats"
  spec.version       = GHRepoStats::VERSION
  spec.authors       = ["Rahsun McAfee"]
  spec.email         = ["rahsun@rahsunmcafee.com"]
  spec.description   = %q{Github Archive Stats Report Gem}
  spec.summary       = %q{This gem is an exercise in retrieving github archive stats through the Github Archive provided interface}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   << 'gh_repo_stats'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.18"
  spec.add_dependency "yajl-ruby"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "debugger"
end
