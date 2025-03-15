<!-- markdownlint-disable MD013 MD033 -->

# Minitest::AssertErrors

[![Ruby](https://github.com/kematzy/minitest-assert_errors/actions/workflows/ruby.yml/badge.svg?branch=master)](https://github.com/kematzy/minitest-assert_errors/actions/workflows/ruby.yml) - [![Gem Version](https://badge.fury.io/rb/minitest-assert_errors.svg)](https://badge.fury.io/rb/minitest-assert_errors) - [![Minitest Style Guide](https://img.shields.io/badge/code_style-rubocop-briPghtgreen.svg)](https://github.com/rubocop/rubocop-minitest)

Coverage: **100%**

## Introduction

When writing test libraries or extensions for Minitest, you often need to verify that Minitest's
own assertions are working correctly. This gem provides specialized assertions to test if Minitest
itself raises (or doesn't raise) assertion errors with the expected messages.

It's particularly useful when you're developing custom Minitest assertions or testing
testing-related code.

Adds [Minitest](https://github.com/seattlerb/minitest) assertions to test for errors raised or not raised by Minitest itself. Most **useful when testing other Minitest assertions** or as a shortcut to other tests.

## Added Methods

Currently adds the following methods:

### Minitest::Assertions

```ruby
assert_have_error(msg, klass = Minitest::Assertion, &block)
assert_error_raised(msg, klass = Minitest::Assertion, &block)  # alias

assert_no_error(&block)
refute_error(&block)  # alias
refute_error_raised(&block)  # alias
assert_no_error_raised(&block)  # alias
```

### Minitest::Expectations - for use with Minitest::Spec

```ruby
_(actual).must_have_error(msg)

_(actual).wont_have_error()
```

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-assert_errors'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install minitest-assert_errors
```

## Usage

Add the gem to your _Gemfile_ or _.gemspec_ file and then load the gem in your
`test_helper.rb` or `spec_helper.rb` file as follows:

```ruby
require 'minitest/autorun'
require 'minitest/assert_errors'
```

This automatically adds the helper methods to `Minitest::Assertions` and expectations
to `Minitest::Expectations`.

---

## Examples

### `#assert_have_error(:msg, :klass, &blk)`

Tests that a Minitest assertion raises an error with the expected message.

Unlike `assert_raises` which tests for any exception, this specifically tests that Minitest's
own assertions are working as expected.

#### Basic Example

```ruby
# Test that Minitest's assert method raises an error with the specified message
assert_have_error('error message') do
  assert(false, 'error message')
end

# The same test using spec syntax
_{ assert(false, 'error message') }.must_have_error('error message')
```

#### Using Regular Expressions

The expected error message can be a `String` or `Regexp`:

```ruby
# Test that assert_equal produces an error message containing specific text
assert_have_error(/error message.+Actual:\s+\"b\"/m) do
  assert_equal('a', 'b', 'error message')
end

# The same test using spec syntax
_{
  assert_equal('a', 'b', 'error message')
}.must_have_error(/error message.+Actual:\s+\"b\"/m)
```

#### Real-world Use Case

When developing your own custom assertions, you might use this to test that your assertion fails with the right message:

```ruby
# Testing a custom assertion's failure message
def test_my_custom_assertion_has_right_error_message
  assert_have_error("expected value to be awesome, but got boring") do
    assert_awesome("boring")
  end
end
```

---

### `#assert_no_error(&blk)`

Tests that a Minitest assertion does not raise any error, confirming that a test passes correctly.

#### Basic Example

```ruby
# Test that a passing assertion doesn't raise any error
assert_no_error do
  assert(true, 'this should pass')
end

# The same test using spec syntax
_{ assert(true) }.wont_have_error
```

#### Failure Example

If the code inside the block raises a Minitest assertion error, you'll see an error message like this:

```ruby
# This test will fail because the assertion inside fails
assert_no_error do
  assert_equal('a', :a, 'error message')
end

# Will produce an error like:
# "Expected no Minitest error but got: error message.
# Expected: "a"
# Actual: :a"
```

#### Real-world Use Case

When testing a helper method that should produce valid test data:

```ruby
def test_helper_produces_valid_data
  data = generate_test_data
  assert_no_error do
    assert_valid_format(data)
  end
end
```

---

## Development

After checking out the repo, run `bundle install` to install dependencies.
Then, run `bundle exec rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version:
  1) update the version number in `version.rb`
  2) run `bundle exec rake release`, which will create a git tag for the version
  3) push git commits and tags
  4) push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/kematzy/minitest-assert_errors).

This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2015 - 2024 Kematzy

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
