# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

if ENV['COVERAGE']
  require File.join(File.dirname(File.expand_path(__FILE__)), 'minitest_assert_errors_coverage')
  SimpleCov.minitest_assert_errors_coverage
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rubygems'
require 'minitest/autorun'
require 'minitest/assert_errors'
require 'minitest/rg'
