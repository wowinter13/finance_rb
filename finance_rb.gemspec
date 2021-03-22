# frozen_string_literal: true

require_relative "lib/finance/version"

Gem::Specification.new do |spec|
  spec.name          = "finance_rb"
  spec.version       = Finance::VERSION
  spec.authors       = ["Vlad Dyachenko"]
  spec.email         = ["vla-dy@yandex.ru"]

  spec.summary       = "A library for finance manipulations in Ruby."
  spec.description   = "A ruby port of numpy-financial functions. "\
  "This library provides a Ruby interface for working with interest rates, "\
  "mortgage amortization, and cashflows and other stuff from finance."
  spec.homepage      = "https://github.com/wowinter13/finance_rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")
  spec.metadata    = {
    'bug_tracker_uri'   => 'https://github.com/wowinter13/finance_rb/issues',
    'changelog_uri'     => "https://github.com/wowinter13/finance_rb/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/github/wowinter13/finance_rb",
    'source_code_uri'   => "https://github.com/wowinter13/finance_rb"
  }

  spec.files         = %w[CHANGELOG.md README.md LICENSE.txt]
  spec.files        += Dir['lib/**/*']
  spec.test_files    = Dir['spec/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
