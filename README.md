<!-- markdownlint-disable MD013 MD033 -->

# Minitest::AssertErrors

[![Ruby](https://github.com/kematzy/minitest-assert_errors/actions/workflows/ruby.yml/badge.svg?branch=master)](https://github.com/kematzy/minitest-assert_errors/actions/workflows/ruby.yml) - [![Gem Version](https://badge.fury.io/rb/minitest-assert_errors.svg)](https://badge.fury.io/rb/minitest-assert_errors) - [![Minitest Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop-minitest)

Coverage: **100%**

Adds [Minitest](https://github.com/seattlerb/minitest) assertions to test for errors raised or not
raised by Minitest itself. Most **useful when testing other Minitest assertions** or as a shortcut
to other tests.

## Added Methods

Currently adds the following methods:

### Minitest::Assertions

- **`assert_have_error()`**
- **`assert_error_raised()`** (alias of `assert_have_error()`)
- **`assert_no_error()`**
- **`:refute_error()`**  (alias of `assert_no_error()`)

### Minitest::Expectations - for use with Minitest::Spec

- **_(actual).`must_have_error(expected_msg)`**

- **_(actual).`wont_have_error()`**

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
`(test|spec)_helper.rb` file as follows:

```ruby
 # <snip...>

 require 'minitest/autorun'
 require 'minitest/assert_errors'

 # <snip...>
```

Adding the above to your `spec_helper.rb` file automatically adds the key
helper methods to the `Minitest::Assertions` to test for Minitest errors
raised or not raised within your tests.

---

## Examples

### `assert_have_error(expected_msg, klass = Minitest::Assertion, &blk)`

&nbsp; -- also aliased as: **`assert_error_raised()`**

Assertion method to test for an error raised by Minitest

```ruby
  assert_have_error('error message') do
    assert(false, 'error message')
  end

  # or

  _{
    assert(false, 'error message')
  }.must_have_error('error message')

```

Produces a longer error message, combining the given error message with
the default error message, when something is wrong.

**NOTE!** The expected error message can be a `String` or `Regexp`.

```ruby
  assert_have_error(/error message.+Actual:\s+\"b\"/m) do
    assert_equal('a','b', 'error message')
  end

  # or

  _{
    assert_equal('a','b', 'error message')
  }.must_have_error(/error message.+Actual:\s+\"b\"/m)
```

---

### `assert_no_error(&blk)`

&nbsp; -- also aliased as: **`refute_error()`** or **`refute_error_raised()`** or
**`assert_no_error_raised()`**

Assertion method to test for no error being raised by Minitest test.

```ruby
  assert_no_error() do
    assert(true, 'error message')
  end

  # or

  _{ assert(true) }.wont_have_error
```

Produces a longer error message, combining the given error message with the
default error message, when something is wrong.

**NOTE!** The expected error message can be a `String` or `Regexp`.

```ruby
 assert_no_error { assert_equal('a', :a, 'error message') }

   #=> "error message.\nExpected: \"a\"\n  Actual: :a"

 proc {
   assert_equal('a', :a, 'error message')
 }.wont_have_error

   #=> "error message.\nExpected: \"a\"\n  Actual: :a"
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
