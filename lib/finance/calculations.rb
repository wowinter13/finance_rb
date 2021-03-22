# frozen_string_literal: true

module Finance
  class Calculations
    class << self
      # Npv computes the Net Present Value of a cash flow series.
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

      alias net_present_value npv
    end
  end
end
