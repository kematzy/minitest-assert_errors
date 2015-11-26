# Minitest::AssertErrors

Adds Minitest assertions to test for errors raised or not raised by Minitest itself. Most **useful 
when testing other Minitest assertions** or as a shortcut to other tests.

Currently adds the following methods:

### Minitest::Assertions

*  **`assert_have_error()`** - also aliased as **`assert_error_raised()`**

* **`assert_no_error()`** - also aliased as **`:refute_error()`**

### Minitest::Expectations - for use with Minitest::Spec

* **actual.`must_have_error(expected_msg)`**

* **actual.`wont_have_error`**

<br>
---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-assert_errors'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-assert_errors

## Usage

Add the gem to your *Gemfile* or *.gemspec* file and then load the gem in your 
`(test|spec)_helper.rb` file as follows:

```ruby
 # <snip...>
 
 require 'minitest/autorun'
 
 require 'minitest/assert_errors'
 
 # <snip...>
```

Adding the above to your `spec_helper.rb` file automatically adds the key helper methods to the 
`Minitest::Assertions` to test for Minitest errors raised or not raised within your tests.

<br>

#### `assert_have_error(expected_msg, klass = Minitest::Assertion, &blk)`
&nbsp; -- also aliased as: **`assert_error_raised()`** 

Assertion method to test for an error raised by Minitest

```ruby
  assert_have_error('error message') { assert(false, 'error message') } 
  
  # or
  
  proc { 
    assert(false, 'error message') 
  }.must_have_error('error message')
  
```    

Produces a longer error message, combining the given error message with the default error message, 
when something is wrong. 

**NOTE!** The expected error message can be a `String` or `Regexp`.

```ruby    
  assert_have_error(/error message.+Actual:\s+\"b\"/m) do
    assert_equal('a','b', 'error message')
  end
  
  # or
  
  proc { 
    assert_equal('a','b', 'error message') 
  }.must_have_error(/error message.+Actual:\s+\"b\"/m)
```

<br>

#### `assert_no_error(&blk)`
&nbsp; -- also aliased as: **`refute_error()`** or **`refute_error_raised()`** or 
**`assert_no_error_raised()`** 

  
Assertion method to test for no error being raised by Minitest test.

```ruby
  assert_no_error() { assert(true, 'error message') }
  
  # or
  
  proc { assert(true) }.wont_have_error
```
 
Produces a longer error message, combining the given error message with the default error message, 
when something is wrong. 

**NOTE!** The expected error message can be a `String` or `Regexp`.
 
```ruby
 assert_no_error { assert_equal('a', :a, 'error message') }
   
   #=> "error message.\nExpected: \"a\"\n  Actual: :a"

 proc { 
   assert_equal('a', :a, 'error message') 
 }.wont_have_error
   
   #=> "error message.\nExpected: \"a\"\n  Actual: :a"
```

<br>
--- 

## Dependencies

This Gem depends upon the following:

### Runtime:

* minitest

### Development & Tests:

* bundler (~> 1.10)
* rake  (~> 10.0)
* minitest-rg

* simplecov [optional]
* rubocop   [optional]

<br>



## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/kematzy/minitest-have_tag). 

This project is intended to be a safe, welcoming space for collaboration, and contributors are 
expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

<br>


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix in a separate branch.
* Add spec tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with Rakefile, version, or history.
  * (if you want to have your own version, that is fine but bump version in a commit by itself 
    I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


<br>

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run 
`bundle exec rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then run 
`bundle exec rake release`, which  will create a git tag for the version, push git commits and tags, 
and push the `.gem` file to [rubygems.org](https://rubygems.org).

<br>


## Copyright

Copyright (c) 2015 Kematzy

Released under the MIT License. See LICENSE for further details.

