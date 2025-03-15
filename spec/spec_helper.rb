# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

# Enable coverage tracking when the 'COVERAGE' environment variable is set
if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    # ignore the test files
    add_filter '/spec/'
    # ignore version testing due to loading in the `.gemspec` file causes issues.
    add_filter 'lib/minitest/assert_errors/version.rb'

    # track all library files
    track_files 'lib/**/*.rb'
  end
end

# Ensure the library path is in the load path
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

# # Set up Bundler before loading gems
# require 'bundler/setup'

# Fix duplicate test runs when using Rake
require 'minitest'
Minitest::Runnable.runnables.clear

# Load Minitest
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/minitest'

# Load the code being tested
require 'minitest/assert_errors'

# Add coloured output
require 'minitest/rg'
