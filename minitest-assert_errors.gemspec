# frozen_string_literal: true

# Load the version number
# NOTE! this load marks the file as executed before the SimpleCov code coverage tests
# which may result in either 0%, or 100% coverage even it has (not?) been tested.
require_relative 'lib/minitest/assert_errors/version'

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

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kematzy/minitest-assert_errors'
  spec.metadata['documentation_uri'] = 'https://github.com/kematzy/minitest-assert_errors'
  spec.metadata['changelog_uri'] = 'https://github.com/kematzy/minitest-assert_errors/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.require_paths = ['lib']

  spec.platform         = Gem::Platform::RUBY
  spec.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  spec.rdoc_options += ['--quiet', '--line-numbers', '--inline-source', '--title',
                        'Minitest::AssertErrors: assertions to test for errors', '--main', 'README.md']

  # register dependencies
  spec.add_dependency('minitest', '>= 5.20.0', '< 6.0')

  # development dependencies are found in the Gemfile

  spec.metadata['rubygems_mfa_required'] = 'true'
end
