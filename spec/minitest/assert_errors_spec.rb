# frozen_string_literal: true

require_relative '../spec_helper'

# class DummyError < StandardError; end

describe Minitest::AssertErrors do
  it 'has a version number' do
    _(Minitest::AssertErrors::VERSION).wont_be_nil
    _(Minitest::AssertErrors::VERSION).must_match(/^\d+\.\d+\.\d+$/)
  end
end

# rubocop:disable Metrics/BlockLength
describe Minitest::Spec do
  describe 'overview' do
    it 'assert(false, "error message") - should catch raised error' do
      assert_have_error('error message') { assert(false, 'error message') }
      # ===
      _ { assert(false, 'error message') }.must_have_error('error message')
    end

    it 'assert(true, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert(true, 'error message') }
      end
      # ===
      assert_no_error { assert(true, 'error message') }

      # ---

      _ do
        _ { assert(true, 'error message') }.must_have_error('error message')
      end.must_have_error('Minitest::Assertion expected but nothing was raised.')

      _ { assert(true, 'error message') }.wont_have_error
    end

    it 'assert_equal(a, b, "error message") - should catch raised error' do
      assert_have_error(/error message.+Actual:\s+"b"/m) { assert_equal('a', 'b', 'error message') }
      # ===
      _ { assert_equal('a', 'b', 'error message') }.must_have_error(/error message.+Actual:\s+"b"/m)
    end

    it 'assert_equal(a,a, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert_equal('a', 'a', 'error message') }
      end
      # ===
      assert_no_error { assert_equal('a', 'a', 'error message') }

      # ----

      _ do
        _ { assert_equal('a', 'a', 'error message') }.must_have_error('error message')
      end.must_have_error('Minitest::Assertion expected but nothing was raised.')
      # ===
      _ { assert_equal('a', 'a', 'error message') }.wont_have_error
    end

    it 'assert_kind_of(Array, {}, "error message") - should catch raised error' do
      assert_have_error(/Expected {} to be a kind of Array, not Hash/m) { assert_kind_of(Array, {}) }
      # ===
      _ { assert_kind_of(Hash, []) }.must_have_error(/Expected \[\] to be a kind of Hash, not Array/m)
    end

    it 'assert_kind_of(Hash, {}, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert_kind_of(Hash, {}, 'error message') }
      end

      assert_no_error { assert_kind_of(Hash, {}, 'error message') }

      # ---

      _ do
        _ { assert_kind_of(Hash, {}, 'error message') }.must_have_error('error message')
      end.must_have_error('Minitest::Assertion expected but nothing was raised.')
      # ===
      _ { assert_kind_of(Hash, {}, 'error message') }.wont_have_error
    end

    it 'assert_nil("notnil", "error message") - should catch raised error' do
      assert_have_error(/error message.+Expected "notnil" to be nil/m) { assert_nil('notnil', 'error message') }
      # ===
      _ { assert_nil('notnil', 'error message') }.must_have_error(/error message.+Expected "notnil" to be nil/m)
    end

    it 'assert_nil(nil, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert_nil(nil, 'error message') }
      end
      # ===
      assert_no_error { assert_nil(nil, 'error message') }

      _ do
        _ { assert_nil(nil, 'error message') }.must_have_error('error message')
      end.must_have_error('Minitest::Assertion expected but nothing was raised.')
      # ===
      _ { assert_nil(nil, 'error message') }.wont_have_error
    end

    # TODO: make this test work properly with appropriate logic and tests
    # it 'assert_raises(DummyError, "error message") - should catch raised error but not incorrect one' do
    #   class DummyError < StandardError; end
    #
    #   # error = assert_raises(DummyError) do
    #   #   raise DummyError, 'This is really bad'
    #   # end
    #   #
    #   # assert_equal 'This is really bad', error.message
    #
    #   # assert_have_error(/error message.+ DummyError expected but nothing was raised/m) do
    #   #   assert_raises(DummyError, 'error message') do
    #   #     # this trigger a test error
    #   #     assert(false)
    #   #   end
    #   # end
    #   # ===
    #   _ do
    #     assert_raises(DummyError, 'error message') { assert(true) }
    #   end.must_have_error(/DummyError expected but nothing was raised/m)
    # end

    it 'assert_raises(Minitest::Assertion, "error message") - no error raised' do
      assert_have_error(/error message.+Minitest::Assertion expected but nothing was raised/m) do
        assert_have_error('error message') do
          assert_raises(Minitest::Assertion, 'error message') { assert(true) }
        end
      end
      # ====
      assert_no_error do
        assert_raises(Minitest::Assertion, 'error message') { assert(false) }
      end

      _ do
        _ do
          assert_raises(Minitest::Assertion, 'error message') { assert(true) }
        end.must_have_error('error message')
      end.must_have_error(/error message.+Minitest::Assertion expected but nothing was raised/m)
      # # ===
      _ do
        assert_raises(Minitest::Assertion, 'error message') { assert(false) }
      end.wont_have_error
    end
  end

  describe '#assert_returns_error()' do
    it 'should return the expected error string when an error is raised by the tested code' do
      assert_returns_error('it works') do
        assert(false, 'it works')
      end

      _(assert_raises(Minitest::Assertion) { assert(false, 'it also works') }.message).must_equal 'it also works'
    end

    it 'should raise an exception when there is no error raised by the tested code' do
      e = assert_raises(Minitest::Assertion) do
        assert_returns_error('it works') do
          assert(true, 'it works')
        end
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

  describe '#assert_no_error()' do
    it 'should be silent when there is no error raised' do
      _ { assert_no_error { assert(true, 'not returned') } }.must_be_silent
    end

    it 'should return true by default when there is no error raised' do
      _(assert_no_error { assert(true, 'not returned') }).must_equal true
    end

    it 'should return the expected error string when an error is raised by the tested code' do
      e = assert_raises(Minitest::Assertion) do
        assert_no_error { assert(false, 'returned error message') }
      end
      _(e.message).must_equal 'returned error message'

      e = assert_raises(Minitest::Assertion) do
        assert_no_error { assert_equal('a', :a) }
      end
      _(e.message).must_equal "Expected: \"a\"\n  Actual: :a"
    end
  end

  describe '#.must_have_error()' do
    it 'should return the expected error string when an error is raised by the tested code' do
      _ do
        assert(false, 'it works')
      end.must_have_error('it works')

      _(assert_raises(Minitest::Assertion) { assert(false, 'it also works') }.message).must_equal 'it also works'
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

  describe '#.wont_have_error()' do
    it 'should be silent when there is no error raised' do
      _ do
        _ { assert(true, 'not returned') }.wont_have_error
      end.must_be_silent
    end

    it 'should return the expected error string when an error is raised by the tested code' do
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
      assert_have_error(/error message.+Expected: "a".+Actual: :a/m) do
        assert_no_error { assert_equal('a', :a, 'error message') }
      end
      _ do
        _ do
          assert_equal('a', :a, 'error message')
        end.wont_have_error
      end.must_have_error(/error message.+Expected: "a".+Actual: :a/m)
    end
  end
end
# rubocop:enable Metrics/BlockLength
