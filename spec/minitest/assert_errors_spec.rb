require_relative '../spec_helper'

describe Minitest::AssertErrors do
  
  it 'has a version number' do
    Minitest::AssertErrors::VERSION.wont_be_nil
    Minitest::AssertErrors::VERSION.must_match %r{^\d+\.\d+\.\d+$}
  end
  
end


describe Minitest::Spec do
  
  describe 'overview' do
    
    it 'assert(false, "error message") - should catch raised error' do
      assert_have_error('error message') { assert(false, 'error message') }
      # ===
      proc { assert(false, 'error message') }.must_have_error('error message')
    end
    
    it 'assert(true, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert(true, 'error message') } 
      end
      # ===
      assert_no_error() { assert(true, 'error message') }
      
      # ---
      
      proc {
        proc { assert(true, 'error message') }.must_have_error('error message')
      }.must_have_error('Minitest::Assertion expected but nothing was raised.')
      
      proc { assert(true, 'error message') }.wont_have_error
    end
    
    it 'assert_equal(a, b, "error message") - should catch raised error' do
      assert_have_error(/error message.+Actual:\s+\"b\"/m) { assert_equal('a','b', 'error message') }
      # ===
      proc { assert_equal('a','b', 'error message') }.must_have_error(/error message.+Actual:\s+\"b\"/m)
    end
    
    it 'assert_equal(a,a, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert_equal('a','a', 'error message') } 
      end
      # ===
      assert_no_error() { assert_equal('a','a', 'error message') }
      
      # ----
      
      proc {
        proc { assert_equal('a','a', 'error message') }.must_have_error('error message')
      }.must_have_error('Minitest::Assertion expected but nothing was raised.')
      # ===
      proc { assert_equal('a','a', 'error message') }.wont_have_error
    end
    
    it 'assert_kind_of(Array, {}, "error message") - should catch raised error' do
      assert_have_error(/Expected {} to be a kind of Array, not Hash/m) { assert_kind_of(Array, {}) }
      # ===
      proc { assert_kind_of(Hash, []) }.must_have_error(/Expected \[\] to be a kind of Hash, not Array/m)
    end
    
    it 'assert_kind_of(Hash, {}, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert_kind_of(Hash, {}, 'error message') } 
      end
      
      assert_no_error() { assert_kind_of(Hash, {}, 'error message') }
      
      # ---
      
      proc {
        proc { assert_kind_of(Hash, {}, 'error message') }.must_have_error('error message')
      }.must_have_error('Minitest::Assertion expected but nothing was raised.')
      # ===
      proc { assert_kind_of(Hash, {}, 'error message') }.wont_have_error
    end
    
    it 'assert_nil("notnil", "error message") - should catch raised error' do
      assert_have_error(/error message.+Expected \"notnil\" to be nil/m) { assert_nil("notnil", "error message") }
      # ===
      proc { assert_nil("notnil", "error message") }.must_have_error(/error message.+Expected \"notnil\" to be nil/m)
    end
    
    it 'assert_nil(nil, "error message") - no error raised' do
      assert_have_error('Minitest::Assertion expected but nothing was raised.') do
        assert_have_error('error message') { assert_nil(nil, 'error message') } 
      end
      # ===
      assert_no_error() { assert_nil(nil, 'error message') }
      
      # --- 
      
      proc {
        proc { assert_nil(nil, 'error message') }.must_have_error('error message')
      }.must_have_error('Minitest::Assertion expected but nothing was raised.')
      # ===
      proc { assert_nil(nil, 'error message') }.wont_have_error
    end
    
    it 'assert_raises(DummyError, "error message") - should catch raised error' do
      class DummyError < StandardError; end
      assert_have_error(/error message.+\[DummyError\] exception expected/m) do
        assert_raises(DummyError, 'error message') { assert(false) }
      end
      # ===
      proc {
        assert_raises(DummyError, 'error message') { assert(false) }
      }.must_have_error(/error message.+\[DummyError\] exception expected/m)
    end
    
    it 'assert_raises(Minitest::Assertion, "error message") - no error raised' do
      assert_have_error(/error message.+Minitest::Assertion expected but nothing was raised/m) do
        assert_have_error('error message') do
          assert_raises(Minitest::Assertion, 'error message') { assert(true) }
        end
      end
      # ====
      assert_no_error() do
        assert_raises(Minitest::Assertion, 'error message') { assert(false) }
      end
      
      proc {
        proc { 
          assert_raises(Minitest::Assertion, 'error message') { assert(true) }
        }.must_have_error('error message')
      }.must_have_error(/error message.+Minitest::Assertion expected but nothing was raised/m)
      # # ===
      proc { 
        assert_raises(Minitest::Assertion, 'error message') { assert(false) }
      }.wont_have_error
    end
    
  end
  
  describe '#assert_returns_error()' do
    
    it 'should return the expected error string when an error is raised by the tested code' do
      assert_returns_error('it works') do
        assert(false, 'it works')
      end
      
      assert_raises(Minitest::Assertion) { assert(false, 'it also works') }
        .message.must_equal 'it also works'
    end
    
    it 'should raise an exception when there is no error raised by the tested code' do
      e = assert_raises(Minitest::Assertion) do
        assert_returns_error('it works') do
          assert(true, 'it works')
        end
      end
      e.message.must_equal 'Minitest::Assertion expected but nothing was raised.'
    end
    
    it 'should raise an exception when the expected error does not match the actual error' do
      e = assert_raises(Minitest::Assertion) do
        assert_returns_error('it worked') do
          assert(false, 'it works')
        end
      end
      e.message.must_equal %Q{Expected: "it worked"\n  Actual: "it works"}
      
      
      e2 = assert_raises(Minitest::Assertion) do
        assert_returns_error('it worked') do
          assert_equal('a', :a)
        end
      end
      e2.message.must_match %r{Expected: \\\"a\\\".+Actual: :a}m
    end
    
  end
  
  describe '#assert_no_error()' do 
    
    it 'should be silent when there is no error raised' do
      proc { assert_no_error { assert(true, 'not returned') } }.must_be_silent
    end
    
    it 'should return true by default when there is no error raised' do
      assert_no_error { assert(true, 'not returned') }.must_equal true
    end
    
    it 'should return the expected error string when an error is raised by the tested code' do
      e = assert_raises(Minitest::Assertion) do
        assert_no_error { assert(false, 'returned error message') }
      end
      e.message.must_equal 'returned error message'
      
      
      e = assert_raises(Minitest::Assertion) do
        assert_no_error { assert_equal('a', :a) }
      end
      e.message.must_equal "Expected: \"a\"\n  Actual: :a"
    end
    
  end
  
  describe '#.must_have_error()' do
    
    it 'should return the expected error string when an error is raised by the tested code' do
      proc {
        assert(false, 'it works')
      }.must_have_error('it works')
      
      assert_raises(Minitest::Assertion) { assert(false, 'it also works') }
        .message.must_equal 'it also works'
    end
    
    it 'should raise an exception when there is no error raised by the tested code' do
      e = assert_raises(Minitest::Assertion) do
        proc { assert(true, 'it works') }.must_have_error('it works')
      end
      e.message.must_equal 'Minitest::Assertion expected but nothing was raised.'
    end
    
    it 'should raise an exception when the expected error does not match the actual error' do
      e = assert_raises(Minitest::Assertion) do
        assert_returns_error('it worked') do
          assert(false, 'it works')
        end
      end
      e.message.must_equal %Q{Expected: "it worked"\n  Actual: "it works"}
      
      
      e2 = assert_raises(Minitest::Assertion) do
        assert_returns_error('it worked') do
          assert_equal('a', :a)
        end
      end
      e2.message.must_match %r{Expected: \\\"a\\\".+Actual: :a}m
    end
    
  end
  
  describe '#.wont_have_error()' do 
    
    it 'should be silent when there is no error raised' do
      proc {  
        proc { assert(true, 'not returned') }.wont_have_error
      }.must_be_silent
    end
    
    it 'should return the expected error string when an error is raised by the tested code' do
      e = assert_raises(Minitest::Assertion) do
        proc { assert(false, 'returned error message') }.wont_have_error 
      end
      e.message.must_equal 'returned error message'
      
      
      e = assert_raises(Minitest::Assertion) do
        proc { assert_equal('a', :a) }.wont_have_error
      end
      e.message.must_equal "Expected: \"a\"\n  Actual: :a"
    end
    
    it 'should handle returning complex message' do
      assert_have_error(/error message.+Expected: \"a\".+Actual: :a/m) do
        assert_no_error { assert_equal('a', :a, 'error message') }
      end
      proc {
        proc { 
          assert_equal('a', :a, 'error message') 
        }.wont_have_error
      }.must_have_error(/error message.+Expected: \"a\".+Actual: :a/m)
    
    end
    
  end
  
end