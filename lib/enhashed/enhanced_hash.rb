class EnhancedHash
  attr_accessor :hash

  def initialize(init_options = {})
    @hash = {}
    init_options.each_pair { |k, v| set(k, v) }
    self
  end

  def to_a
    @hash.values
  end

  def to_h
    @hash
  end

  def method_missing(*args)
    key = args[0].to_sym
    case key[-1]
    when '?'
      key = key[0..-2].to_sym
      true?(key)
    when '='
      key = key[0..-2].to_sym
      set(key, args[1])
    else
      fetch(key)
    end
  end

  def set(*args)
    first_arg = args[0]
    case first_arg
    when String, Symbol
      key           = first_arg.to_sym
      value         = args.at(1).nil? ? true : args[1] # no value, default to true
      @hash[key] = value
    when Hash
      first_arg.each_pair { |k, v| set(k, v) }
    else
      fail ArgumentError.new('Argument to set must be string, symbol or hash (given: %s)' % first_arg.to_s)
    end
  end

  def fetch(key)
    @hash.fetch(key.to_sym, nil)
  end

  # Checks to see that all passed symbols exist
  def has?(*args)
    check_args(args) do |arg|
      @hash.key?(arg.to_sym)
    end
  end

  def has_any?(*args)
    check_any_args(args) do |arg|
      @hash.key?(arg.to_sym)
    end
  end

  # Checks to see that all passed symbols exist and are truthy
  def true?(*args)
    check_args(args) do |arg|
      !@hash[arg.to_sym].blank?
    end
  end

  # Checks to see that any of the passed symbols exists and is truthy
  def true_any?(*args)
    check_any_args(args) do |arg|
      !@hash[arg.to_sym].blank?
    end
  end

  # Checks to see that all passed symbols exist and are falsey
  def false?(*args)
    check_args(args) do |arg|
      @hash[arg.to_sym].blank?
    end
  end

  # Checks to see that any of the passed symbols exists and is falsey
  def false_any?(*args)
    check_any_args(args) do |arg|
      @hash[arg.to_sym].blank?
    end
  end

  def debug?
    @hash[:loglevel].upcase == 'DEBUG'
  end

  def delete_field(key)
    key = key.to_sym
    @hash.delete(key) if has?(key)
  end

  private

  # Check each of the args that are passed in using the block defined in the
  # original method. If we're looking to match ALL values, then we assume true
  # until proven false; if we're looking for ANY values, we assume false until
  # proven true (and can then stop looking at further arguments).
  def do_arg_check(args, all = true)
    bool = all
    args.each do |arg|
      case arg
      when Symbol, String
        if all
          bool = yield(arg)
        else
          if yield(arg)
            bool = true
            break
          end
        end
      else
        fail ArgumentError.new('Argument to set must be string or symbol (given: %s)' % arg.to_s)
      end
    end
    bool
  end

  def check_args(args, &block)
    do_arg_check(args, true, &block)
  end

  def check_any_args(args, &block)
    do_arg_check(args, false, &block)
  end
end

