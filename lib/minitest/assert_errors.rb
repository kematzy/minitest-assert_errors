# frozen_string_literal: true

require 'minitest'

# loading core files using relative paths
# require_relative 'snapshot/version'

# Alternative loading version when the `lib` directory is in the `$LOAD_PATH`
require 'minitest/assert_errors/version'

# NOTE! loading files in this manner marks the file as 100% covered in code coverage tests
# even though it has not been tested

module Minitest
  # Add support for assert syntax
  module Assertions
    # Asserts that the given block raises a Minitest error with the expected message
    #
    # @param msg [String, Regexp] The expected error message or pattern
    # @param klass [Class] The expected error class, defaults to Minitest::Assertion
    # @yield Block that should raise the expected error
    # @yieldparam blk [Proc] The original block passed to the assertion
    #
    # @raise [Minitest::Assertion] If block doesn't raise expected error with expected message
    #
    # @return [void]
    #
    # @example Testing for an exact error message
    #   assert_have_error('error message') { assert(false, 'error message') }
    #
    # @example Using expect syntax
    #   proc { assert(false, 'error message') }.must_have_error('error message')
    #
    # @example Testing with a regular expression
    #   assert_have_error(/error message.+Actual:\s+\"b\"/m) do
    #     assert_equal('a','b', 'error message')
    #   end
    #
    # @example Using expect syntax with regular expression
    #   _ {
    #     assert_equal('a','b', 'error message')
    #   }.must_have_error(/error message.+Actual:\s+\"b\"/m)
    #
    def assert_have_error(msg, klass = Minitest::Assertion, &blk)
      e = assert_raises(klass) do
        yield(blk) if block_given?
      end
      assert_match(msg, e.message) if msg.is_a?(Regexp)
      assert_equal(msg, e.message) if msg.is_a?(String)
    end
    alias assert_error_raised assert_have_error
    # backwards compat. DO NOT USE!
    alias assert_returns_error assert_have_error

    # Asserts that the given block does not raise a Minitest error
    #
    # @yield Block that should not raise an error
    # @yieldparam blk [Proc] The original block passed to the assertion
    #
    # @raise [Minitest::Assertion] If the block raises an error
    #
    # @return [void]
    #
    # @example Testing that no error is raised
    #   assert_no_error() { assert(true, 'error message') }
    #
    # @example Using expect syntax
    #   proc { assert(true) }.wont_have_error
    #
    # @example Testing an assertion that would fail
    #   assert_no_error { assert_equal('a', :a, 'error message') }
    #     #=> "error message.\nExpected: \"a\"\n  Actual: :a"
    #
    # @example Using expect syntax with failing assertion
    #   proc {
    #     assert_equal('a', :a, 'error message')
    #   }.wont_have_error
    #     #=> "error message.\nExpected: \"a\"\n  Actual: :a"
    #
    def assert_no_error(&blk)
      assert_silent do
        yield(blk) if block_given?
      end
    end
    alias refute_error assert_no_error
    alias refute_error_raised assert_no_error
    alias assert_no_error_raised assert_no_error
  end

  # add support for Spec syntax
  module Expectations
    infect_an_assertion :assert_have_error, :must_have_error, :block
    infect_an_assertion :assert_no_error,   :wont_have_error, :block
  end
end
