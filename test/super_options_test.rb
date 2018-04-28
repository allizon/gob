require_relative 'test_helper'

class SuperOptionsTest < Minitest::Test
  def setup
    @options = SuperOptions.new
    @options.set(a: 1, b: 2, c: 3)
  end

  def test_that_it_has_a_version_number
    refute_nil ::SuperOptions::VERSION
  end

  def test_to_a_should_return_an_array
    assert @options.to_a.is_a?(Array)
  end

  def test_to_h_should_return_a_hash
    assert @options.to_h.is_a?(Hash)
  end

  def test_all_hash_keys_are_symbols_on_initialization
    options = SuperOptions.new('a' => 1, 'b' => 2, 'c' => 3)
    options.options.each_key { |k| assert k.is_a?(Symbol) }
  end

  def test_magic_method_fetches_requested_variable
    assert_equal @options.a, 1
    assert_equal @options.d, nil
  end

  def test_magic_method_equals_sets_requested_variable
    @options.d = 4
    assert_equal @options.d, 4
  end

  def test_magic_method_question_fetches_boolean
    assert @options.a?
    refute @options.d?
  end

  def test_fetch_fetches_requested_variable
    assert_equal @options.fetch(:a), 1
    assert_equal @options.fetch(:d), nil
  end

  def test_set_accepts_symbol_and_sets_value_to_true
    @options.set(:a_symbol)
    assert @options.a_symbol?
  end

  def test_set_accepts_key_value_pair
    @options.set('a_string', 'value')
    assert_equal @options.a_string, 'value'

    @options.set(:a_symbol, 'value')
    assert_equal @options.a_symbol, 'value'
  end

  def test_set_accepts_a_hash_and_sets_each_key_value_pair
    @options.set(x: 1, y: 2, z: 3)
    assert_equal @options.x, 1
    assert_equal @options.y, 2
    assert_equal @options.z, 3
  end

  def test_set_only_accepts_string_symbol_or_hash
    [1, nil, true].each do |arg|
      assert_raises ArgumentError do
        @options.set(arg, 'value')
      end
    end
  end

  def test_has_returns_true_if_key_exists_regardless_of_value
    @options.set(e: false)

    assert @options.has?(:a)
    refute @options.has?(:d)
    assert @options.has?(:e)
  end

  def test_has_returns_true_if_all_passed_symbols_exist
    assert @options.has?(:a, :b, :c)
    assert @options.has?('a', 'b', 'c')
    refute @options.has?(:a, :d)
    assert_raises ArgumentError do
      @options.has?(:a, 1)
    end
  end

  def test_has_any_returns_true_if_any_of_the_passed_symbols_exist
    assert @options.has_any?(:a, :b, :c, :d)
    assert @options.has_any?('a', 'b', 'c', 'd')
    refute @options.has_any?(:d, :e)
    assert @options.has_any?(:a, 1)
    assert_raises ArgumentError do
      @options.has_any?(1, :a)
    end
  end

  def test_true_returns_true_for_truthy_values
    assert @options.true?(:a)
    refute @options.true?(:d)
    check_falsey_types(:refute, :true?)
  end

  def test_true_returns_true_if_all_passed_symbols_are_truthy
    @options.set(e: false)

    assert @options.true?(:a, :b, :c)
    assert @options.true?('a', 'b', 'c')
    refute @options.true?(:a, :d)
    assert_raises ArgumentError do
      @options.true?(:a, 1)
    end
    refute @options.true?(:a, :e)
  end

  def test_true_any_returns_true_if_any_of_the_passed_symbols_are_truthy
    assert @options.true_any?(:a, :b, :c, :d)
    assert @options.true_any?('a', 'b', 'c', 'd')
    refute @options.true_any?(:d, :e)
    assert @options.true_any?(:a, 1)
    assert_raises ArgumentError do
      @options.true_any?(1, :a)
    end
  end

  def test_false_returns_true_for_falsey_values
    refute @options.false?(:a)
    assert @options.false?(:d)
    check_falsey_types(:assert, :false?)
  end

  def test_false_returns_true_if_all_passed_symbols_are_falsey
    @options.set(e: false)

    refute @options.false?(:a, :b, :c)
    refute @options.false?('a', 'b', 'c')
    assert @options.false?(:d, :e)
    assert_raises ArgumentError do
      @options.false?(:a, 1)
    end
  end

  def test_false_any_returns_true_if_any_of_the_passed_symbols_are_falsey
    assert @options.false_any?(:a, :b, :c, :d)
    assert @options.false_any?('a', 'b', 'c', 'd')
    refute @options.false_any?(:a, :b)
    assert @options.false_any?(:d, 1)
    assert_raises ArgumentError do
      @options.false_any?(:a, 1)
    end
  end

  def test_debug_returns_true_only_when_loglevel_is_debug
    @options.set(loglevel: 'debug')
    assert @options.debug?

    @options.set(loglevel: 'info')
    refute @options.debug?
  end

  def test_delete_field_removes_field_entirely
    @options.delete_field(:b)
    refute @options.has?(:b)
    assert_equal @options.b, nil
  end

  private

  def check_falsey_types(assert, truth)
    # Don't bother testing nil - setting nil actually sets value to true!
    # Also, Ruby considers "0" a truthy value.
    [false, '', [], {}].each do |val|
      @options.set(e: val)
      send(assert, @options.send(truth, (:e)))
    end
  end
end

