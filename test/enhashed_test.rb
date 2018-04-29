require_relative 'test_helper'

class GobTest < Minitest::Test
  def setup
    @hash = Gob.new
    @hash.set(a: 1, b: 2, c: 3)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Gob::VERSION
  end

  def test_to_a_should_return_an_array_of_values
    assert @hash.to_a.is_a?(Array)
    assert_equal [1, 2, 3], @hash.to_a
  end

  def test_to_h_should_return_a_hash
    assert @hash.to_h.is_a?(Hash)
    assert_equal ({ a: 1, b: 2, c: 3 }), @hash.to_h
  end

  def test_all_hash_keys_are_symbols_on_initialization
    gob = Gob.new('a' => 1, 'b' => 2, 'c' => 3)
    gob.hash.each_key { |k| assert k.is_a?(Symbol) }
  end

  def test_magic_method_fetches_requested_variable
    assert_equal @hash.a, 1
    assert_equal @hash.d, nil
  end

  def test_magic_method_equals_sets_requested_variable
    @hash.d = 4
    assert_equal @hash.d, 4
  end

  def test_magic_method_question_fetches_boolean
    assert @hash.a?
    refute @hash.d?
  end

  def test_fetch_fetches_requested_variable
    assert_equal @hash.fetch(:a), 1
    assert_equal @hash.fetch(:d), nil
  end

  def test_set_accepts_symbol_and_sets_value_to_true
    @hash.set(:a_symbol)
    assert @hash.a_symbol?
  end

  def test_set_accepts_key_value_pair
    @hash.set('a_string', 'value')
    assert_equal @hash.a_string, 'value'

    @hash.set(:a_symbol, 'value')
    assert_equal @hash.a_symbol, 'value'
  end

  def test_set_accepts_a_hash_and_sets_each_key_value_pair
    @hash.set(x: 1, y: 2, z: 3)
    assert_equal @hash.x, 1
    assert_equal @hash.y, 2
    assert_equal @hash.z, 3
  end

  def test_set_only_accepts_string_symbol_or_hash
    [1, nil, true].each do |arg|
      assert_raises ArgumentError do
        @hash.set(arg, 'value')
      end
    end
  end

  def test_has_returns_true_if_key_exists_regardless_of_value
    @hash.set(e: false)

    assert @hash.has?(:a)
    refute @hash.has?(:d)
    assert @hash.has?(:e)
  end

  def test_has_returns_true_if_all_passed_symbols_exist
    assert @hash.has?(:a, :b, :c)
    assert @hash.has?('a', 'b', 'c')
    refute @hash.has?(:a, :d)
    assert_raises ArgumentError do
      @hash.has?(:a, 1)
    end
  end

  def test_has_any_returns_true_if_any_of_the_passed_symbols_exist
    assert @hash.has_any?(:a, :b, :c, :d)
    assert @hash.has_any?('a', 'b', 'c', 'd')
    refute @hash.has_any?(:d, :e)
    assert @hash.has_any?(:a, 1)
    assert_raises ArgumentError do
      @hash.has_any?(1, :a)
    end
  end

  def test_true_returns_true_for_truthy_values
    assert @hash.true?(:a)
    refute @hash.true?(:d)
    check_falsey_types(:refute, :true?)
  end

  def test_true_returns_true_if_all_passed_symbols_are_truthy
    @hash.set(e: false)

    assert @hash.true?(:a, :b, :c)
    assert @hash.true?('a', 'b', 'c')
    refute @hash.true?(:a, :d)
    assert_raises ArgumentError do
      @hash.true?(:a, 1)
    end
    refute @hash.true?(:a, :e)
  end

  def test_true_any_returns_true_if_any_of_the_passed_symbols_are_truthy
    assert @hash.true_any?(:a, :b, :c, :d)
    assert @hash.true_any?('a', 'b', 'c', 'd')
    refute @hash.true_any?(:d, :e)
    assert @hash.true_any?(:a, 1)
    assert_raises ArgumentError do
      @hash.true_any?(1, :a)
    end
  end

  def test_false_returns_true_for_falsey_values
    refute @hash.false?(:a)
    assert @hash.false?(:d)
    check_falsey_types(:assert, :false?)
  end

  def test_false_returns_true_if_all_passed_symbols_are_falsey
    @hash.set(e: false)

    refute @hash.false?(:a, :b, :c)
    refute @hash.false?('a', 'b', 'c')
    assert @hash.false?(:d, :e)
    assert_raises ArgumentError do
      @hash.false?(:a, 1)
    end
  end

  def test_false_any_returns_true_if_any_of_the_passed_symbols_are_falsey
    assert @hash.false_any?(:a, :b, :c, :d)
    assert @hash.false_any?('a', 'b', 'c', 'd')
    refute @hash.false_any?(:a, :b)
    assert @hash.false_any?(:d, 1)
    assert_raises ArgumentError do
      @hash.false_any?(:a, 1)
    end
  end

  def test_debug_returns_true_only_when_loglevel_is_debug
    @hash.set(loglevel: 'debug')
    assert @hash.debug?

    @hash.set(loglevel: 'info')
    refute @hash.debug?
  end

  def test_delete_field_removes_field_entirely
    @hash.delete_field(:b)
    refute @hash.has?(:b)
    assert_equal @hash.b, nil
  end

  private

  def check_falsey_types(assert, truth)
    # Don't bother testing nil - setting nil actually sets value to true!
    # Also, Ruby considers "0" a truthy value.
    [false, '', [], {}].each do |val|
      @hash.set(e: val)
      send(assert, @hash.send(truth, (:e)))
    end
  end
end

