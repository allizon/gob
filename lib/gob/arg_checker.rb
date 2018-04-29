module Gob
  class ArgChecker
    # Check each of the args that are passed in using the block defined in the
    # original method. If we're looking to match ALL values, then we assume true
    # until proven false; if we're looking for ANY values, we assume false until
    # proven true (and can then stop looking at further arguments).
    def self.do_arg_check(args, all = true)
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

    def self.check_args(args, &block)
      do_arg_check(args, true, &block)
    end

    def self.check_any_args(args, &block)
      do_arg_check(args, false, &block)
    end
  end
end

