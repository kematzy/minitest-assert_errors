# frozen_string_literal: true

# Use this when using `bundle exec ...`
require 'spec_helper'

# Use this when using `rake spec` (without bundle)
# require_relative '../spec_helper'

describe 'Minitest' do
  describe 'AssertErrors' do
    describe '::VERSION' do
      it 'has a version number' do
        _(Minitest::AssertErrors::VERSION).wont_be_nil
      end
    end
    # /::VERSION
  end
  # /AssertErrors

  describe '::Assertions' do
    describe '#assert_have_error(:msg, :klass, &blk)' do
      it 'should catch raised error' do
        assert_have_error('error message') { assert(false, 'error message') }
      end

      it 'should match error message with regex' do
        assert_have_error(/error message.+Actual:\s+"b"/m) do
          assert_equal('a', 'b', 'error message')
        end
      end

      it 'should raise when no error is raised' do
        assert_have_error('Minitest::Assertion expected but nothing was raised.') do
          assert_have_error('error message') { assert(true, 'error message') }
        end
      end

      it 'should work with different assertion methods' do
        assert_have_error(/Expected {} to be a kind of Array, not Hash/m) do
          assert_kind_of(Array, {})
        end

        assert_have_error(/error message.+Expected "notnil" to be nil/m) do
          assert_nil('notnil', 'error message')
        end
      end
    end
    # /#assert_have_error(:msg, :klass, &blk)

    describe '#assert_error_raised(:msg, :klass, &blk)' do
      it 'should return the expected error string when an error is raised by the tested code' do
        assert_error_raised('it works') do
          assert(false, 'it works')
        end

        _(
          assert_raises(Minitest::Assertion) { assert(false, 'it also works') }.message
        ).must_equal 'it also works'
      end

      it 'should raise an exception when there is no error raised by the tested code' do
        e = assert_raises(Minitest::Assertion) do
          assert_error_raised('it works') do
            assert(true, 'it works')
          end
        end

        _(e.message).must_equal 'Minitest::Assertion expected but nothing was raised.'
      end

      it 'should raise an exception when the expected error does not match the actual error' do
        e = assert_raises(Minitest::Assertion) do
          assert_error_raised('it worked') do
            assert(false, 'it works')
          end
        end

        _(e.message).must_equal %(Expected: "it worked"\n  Actual: "it works")

        e2 = assert_raises(Minitest::Assertion) do
          assert_error_raised('it worked') do
            assert_equal('a', :a)
          end
        end

        _(e2.message).must_match(/Expected: \\"a\\".+Actual: :a/m)
      end
    end
    # /#assert_error_raised(:msg, :klass, &blk)

    describe '#assert_no_error(&blk)' do
      it 'should be silent when there is no error raised' do
        _ { assert_no_error { assert(true, 'not returned') } }.must_be_silent
      end

      it 'should return true by default when there is no error raised' do
        _(assert_no_error { assert(true, 'not returned') }).must_equal true
      end

      it 'should raise when an error is raised by the tested code' do
        e = assert_raises(Minitest::Assertion) do
          assert_no_error { assert(false, 'returned error message') }
        end

        _(e.message).must_equal 'returned error message'

        e = assert_raises(Minitest::Assertion) do
          assert_no_error { assert_equal('a', :a) }
        end

        _(e.message).must_equal "Expected: \"a\"\n  Actual: :a"
      end

      it 'should handle returning complex message' do
        assert_have_error(/error message.+Expected: "a".+Actual: :a/m) do
          assert_no_error { assert_equal('a', :a, 'error message') }
        end
      end
    end
    # /#assert_no_error(&blk)

    describe '#refute_error(&blk) alias' do
      it 'should be silent when there is no error raised' do
        _ { refute_error { assert(true, 'not returned') } }.must_be_silent
      end

      it 'should return true by default when there is no error raised' do
        _(refute_error { assert(true, 'not returned') }).must_equal true
      end

      it 'should raise when an error is raised by the tested code' do
        e = assert_raises(Minitest::Assertion) do
          refute_error { assert(false, 'returned error message') }
        end

        _(e.message).must_equal 'returned error message'

        e = assert_raises(Minitest::Assertion) do
          refute_error { assert_equal('a', :a) }
        end

        _(e.message).must_equal "Expected: \"a\"\n  Actual: :a"
      end

      it 'should handle returning complex message' do
        assert_have_error(/error message.+Expected: "a".+Actual: :a/m) do
          refute_error { assert_equal('a', :a, 'error message') }
        end
      end
    end
    # /#refute_error(&blk) alias

    describe '#refute_error_raised(&blk) alias' do
      it 'should be silent when there is no error raised' do
        _ { refute_error_raised { assert(true, 'not returned') } }
          .must_be_silent
      end

      it 'should return true by default when there is no error raised' do
        _(refute_error_raised { assert(true, 'not returned') }).must_equal true
      end
    end
    # /#refute_error_raised(&blk) alias

    describe 'integration examples' do
      it 'provides a clean API for assertions and expectations' do
        assert_have_error('error message') { assert(false, 'error message') }
        assert_no_error { assert(true, 'error message') }
      end

      it 'works with various assertion methods' do
        assert_have_error(/Actual:\s+"b"/m) { assert_equal('a', 'b') }
        assert_no_error { assert_equal('a', 'a') }

        # assert_kind_of
        assert_have_error(/Expected {} to be a kind of Array/m) { assert_kind_of(Array, {}) }
        assert_no_error { assert_kind_of(Hash, {}) }
      end
    end
  end
  # /::Assertions

  describe '::Expectations' do
    describe '.#must_have_error(:klass)' do
      it 'should return the expected error string when an error is raised by the tested code' do
        _ do
          assert(false, 'it works')
        end.must_have_error('it works')

        _(assert_raises(Minitest::Assertion) do
          assert(false, 'it also works')
        end.message).must_equal 'it also works'
      end

      it 'should raise an exception when there is no error raised by the tested code' do
        e = assert_raises(Minitest::Assertion) do
          _ { assert(true, 'it works') }.must_have_error('it works')
        end

        _(e.message).must_equal 'Minitest::Assertion expected but nothing was raised.'
      end

      it 'should raise an exception when the expected error does not match the actual error' do
        e = assert_raises(Minitest::Assertion) do
          assert_returns_error('it worked') do
            assert(false, 'it works')
          end
        end

        _(e.message).must_equal %(Expected: "it worked"\n  Actual: "it works")

        e2 = assert_raises(Minitest::Assertion) do
          assert_returns_error('it worked') do
            assert_equal('a', :a)
          end
        end

        _(e2.message).must_match(/Expected: \\"a\\".+Actual: :a/m)
      end
    end
    # /.#must_have_error(:klass)

    describe '.#wont_have_error(:klass)' do
      it 'should be silent when there is no error raised' do
        _ do
          _ { assert(true, 'not returned') }.wont_have_error
        end.must_be_silent
      end

      it 'returns the expected error string when an error is raised by the tested code' do
        e = assert_raises(Minitest::Assertion) do
          _ { assert(false, 'returned error message') }.wont_have_error
        end

        _(e.message).must_equal 'returned error message'

        e = assert_raises(Minitest::Assertion) do
          _ { assert_equal('a', :a) }.wont_have_error
        end

        _(e.message).must_equal "Expected: \"a\"\n  Actual: :a"
      end

      it 'should handle returning complex message' do
        _ do
          _ do
            assert_equal('a', :a, 'error message')
          end.wont_have_error
        end.must_have_error(/error message.+Expected: "a".+Actual: :a/m)
      end
    end
    # /.#wont_have_error(:klass)

    describe 'integration examples' do
      it 'provides a clean API for assertions and expectations' do
        _ { assert(false, 'error message') }.must_have_error('error message')
        _ { assert(true, 'error message') }.wont_have_error
      end

      it 'works with various assertion methods' do
        _ { assert_equal('a', 'b') }.must_have_error(/Actual:\s+"b"/m)
        _ { assert_equal('a', 'a') }.wont_have_error

        # assert_kind_of
        _ { assert_kind_of(Array, {}) }.must_have_error(/Expected {} to be a kind of Array/m)
        _ { assert_kind_of(Hash, {}) }.wont_have_error
      end
    end
  end
  # /::Expectations
end
# /Minitest
