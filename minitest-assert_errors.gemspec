# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'minitest/assert_errors/version'

Gem::Specification.new do |spec|
  spec.name          = 'minitest-assert_errors'
  spec.version       = Minitest::AssertErrors::VERSION
  spec.authors       = ['Kematzy']
  spec.email         = ['kematzy@gmail.com']

  spec.summary       = 'Adds Minitest assertions to test for errors raised or not raised by Minitest itself'
  spec.description   = 'Adds Minitest assertions to test for errors raised or not \
          raised by Minitest itself. Most useful when testing other Minitest assertions.'
  spec.homepage      = 'https://github.com/kematzy/minitest-assert_errors'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.platform         = Gem::Platform::RUBY
  spec.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  spec.rdoc_options += ['--quiet', '--line-numbers', '--inline-source', '--title',
                        'Minitest::AssertErrors: assertions to test for errors', '--main', 'README.md']

  spec.add_dependency('minitest', '~> 5.25.0', '>= 5.20.0')

  spec.metadata['rubygems_mfa_required'] = 'true'
end
