# frozen_string_literal: true

require 'minitest'

# loading core files using relative paths
# require_relative 'snapshot/version'

# Alternative loading version when the `lib` directory is in the `$LOAD_PATH`
require 'minitest/assert_errors/version'

# NOTE! loading files in this manner marks the file as 100% covered in code coverage tests
# even though it has not been tested


# reopening to add additional functionality
module Minitest
  # Add support for assert syntax
  module Assertions
    # Assertion method to test for an error raised by Minitest
    #
    #     assert_have_error('error message') { assert(false, 'error message') }
    #
    #     proc { assert(false, 'error message') }.must_have_error('error message')
    #
    #
    # Produces an extensive error message, combining the given error message with the default error
    # message, when something is wrong.
    #
    # <b>NOTE!</b> The expected error message can be a +String+ or +Regexp+.
    #
    #     assert_have_error(/error message.+Actual:\s+\"b\"/m) do
    #       assert_equal('a','b', 'error message')
    #     end
    #
    #     # or
    #
    #     proc {
    #       assert_equal('a','b', 'error message')
    #     }.must_have_error(/error message.+Actual:\s+\"b\"/m)
    #
    #
    def assert_have_error(expected_msg, klass = Minitest::Assertion, &blk)
      e = assert_raises(klass) do
        yield(blk) if block_given?
      end
      assert_match(expected_msg, e.message) if expected_msg.is_a?(Regexp)
      assert_equal(expected_msg, e.message) if expected_msg.is_a?(String)
    end
    alias assert_error_raised assert_have_error
    # backwards compat. DO NOT USE!
    alias assert_returns_error assert_have_error

    # Assertion method to test for no error being raised by Minitest
    #
    #     assert_no_error() { assert(true, 'error message') }
    #
    #     proc { assert(true) }.wont_have_error
    #
    # Produces an extensive error message, combining the given error message with
    # the default error message, when something is wrong.
    #
    # <b>NOTE!</b> The expected error message can be a +String+ or +Regexp+.
    #
    #     assert_no_error { assert_equal('a', :a, 'error message') }
    #       #=> "error message.\nExpected: \"a\"\n  Actual: :a"
    #
    #     proc {
    #       assert_equal('a', :a, 'error message')
    #     }.wont_have_error
    #       #=> "error message.\nExpected: \"a\"\n  Actual: :a"
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
