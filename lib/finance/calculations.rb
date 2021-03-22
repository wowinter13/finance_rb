# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/newton'

include Newton

module Finance
  class Calculations
    class << self
      # Npv computes the Net Present Value of a cash flow series.
      #
      # @return [Numeric] The NPV of the input cash flow series `values` at the discount `rate`.
      #
      # @param [Numeric] :rate A discount rate applied once per period.
      # @param [Array<Numeric>] :values The values of the time series of cash flows.
      # 
      # @example
      #   require 'finance_rb'
      #   Finance::Calculations.npv(0.1, [-1000, 100, 100, 100]) #=> -789.3518518518517
      #
      # @see http://en.wikipedia.org/wiki/Net_present_value
      # @see L. J. Gitman, “Principles of Managerial Finance, Brief,” 3rd ed.,
      #   Addison-Wesley, 2003, pg. 346.
      def npv(rate, values)
        npv_value = 0.0
        values.each_with_index do |current_value, pow_index|
          npv_value += current_value / (1.0 + rate) ** pow_index
        end
        npv_value
      end

      # IRR computes the Rate of Interest per period.
      #
      # @return [Float] Internal Rate of Return for periodic input values.
      #
      # @param [Array<Numeric>] :values Input cash flows per time period.
      #
      # @example
      #   require 'finance_rb'
      #   Finance::Calculations.irr([-100, 0, 0, 74]) #=> 0.14299344106053188
      #
      # @see http://en.wikipedia.org/wiki/Internal_rate_of_return
      # @see L. J. Gitman, "Principles of Managerial Finance, Brief," 3rd ed.,
      #   Addison-Wesley, 2003, pg. 348.
      def irr(values)
        inflows, outflows = values.partition{ |i| i >= 0 }
        if inflows.empty? || outflows.empty?
          return 0.0
        end

        func = BigDecimal.limit(100)
        func = Function.new(values)
        rate = [ func.one ]
        nlsolve(func, rate)
        rate[0].to_f
      end

      alias net_present_value npv
      alias internal_return_rate irr

      private

      # Base class for working with Newton's Method.
      # For more details, see Bigdecimal::Newton.
      # @api private
      class Function
        def initialize(values)
          @zero   = BigDecimal("0.0")
          @one    = BigDecimal("1.0")
          @two    = BigDecimal("2.0")
          @ten    = BigDecimal("10.0")
          @eps    = BigDecimal("1.0e-16")
          @values = values
        end
        
        def zero; @zero; end
        def one ; @one;  end
        def two ; @two;  end
        def ten ; @ten;  end
        def eps ; @eps;  end

        def values(x); [Finance::Calculations.npv(x[0], @values)]; end
      end
    end
  end
end
