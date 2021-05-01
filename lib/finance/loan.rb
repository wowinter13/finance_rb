# frozen_string_literal: true

module Finance
  class Loan
    PAYMENT_TYPE_MAPPING = { end: 0, beginning: 1 }.freeze

    # @return [Float] The amount of loan request (I.e. a present value)
    #   You can use #pv method to calculate value if param is not defined.
    #   Defaults to 0.
    attr_accessor :amount

    # @return [Integer] Specification of whether payment is made
    #   at the beginning (ptype = 1) or the end (ptype = 0) of each period.
    #   Defaults to {:end, 0}.
    attr_accessor :ptype

    # @return [Float] The nominal annual rate of interest as decimal (not per cent).
    #   (e.g., 13% -> 0.13)
    #   Defaults to 0.
    attr_accessor :nominal_rate

    # @return [Float] The monthly rate is the nominal annual rate divided by 12.
    #   Defaults to 0.
    attr_reader :monthly_rate

    # @return [Float] The number of periods to be compounded for. (I.e. Nper())
    #   Defaults to 1.
    attr_accessor :duration

    # @return [Float] Future value.
    #   You can use #fv method to calculate value if param is not defined.
    #   Defaults to 0.
    attr_accessor :future_value

    # @return [Float] The (fixed) periodic payment.
    #   You can use #pmt method to calculate value if param is not defined.
    attr_accessor :payment

    # @return [Float] Period under consideration.
    attr_accessor :period

    # Create a new Loan instance.
    def initialize(**options)
      initialize_payment_type(options[:ptype])
      @nominal_rate  = options.fetch(:nominal_rate, 0).to_f
      @duration      = options.fetch(:duration, 1).to_f
      @amount        = options.fetch(:amount, 0).to_f
      @future_value  = options.fetch(:future_value, 0).to_f
      @period        = options[:period]
      @payment       = options[:payment]
      @monthly_rate  = @nominal_rate / 12
    end

    # Pmt computes the payment against a loan principal plus interest (future_value = 0).
    #   It can also be used to calculate the recurring payments needed to achieve
    #   a certain future value given an initial deposit,
    #   a fixed periodically compounded interest rate, and the total number of periods.
    #
    #   Required Loan arguments: nominal_rate, duration, amount, future_value*
    #
    # @return [Numeric] The (fixed) periodic payment.
    #
    # @example
    #   require 'finance_rb'
    #   Finance::Loan.new(nominal_rate: 0.1, duration: 12, amount: 1000, ptype: :end).pmt
    #   #=> 87.9158872300099
    #
    # @see http://www.oasis-open.org/committees/documents.php?wg_abbrev=office-formulaOpenDocument-formula-20090508.odt
    # @see [WRW] Wheeler, D. A., E. Rathke, and R. Weir (Eds.) (2009, May).
    #   Open Document Format for Office Applications (OpenDocument)v1.2,
    #   Part 2: Recalculated Formula (OpenFormula) Format - Annotated Version,
    #   Pre-Draft 12. Organization for the Advancement of Structured Information
    #   Standards (OASIS). Billerica, MA, USA. [ODT Document].
    def pmt
      factor = (1.0 + monthly_rate)**duration
      second_factor =
        if monthly_rate.zero?
          duration
        else
          (factor - 1) * (1 + monthly_rate * ptype) / monthly_rate
        end

      -((future_value + amount * factor) / second_factor)
    end

    # IPmt computes interest payment for a loan under a given period.
    #
    #   Required Loan arguments: period, nominal_rate, duration, amount, future_value*
    #
    # @return [Float] Interest payment for a loan.
    #
    # @example
    #   require 'finance_rb'
    #   Finance::Loan.new(nominal_rate: 0.0824, duration: 12, amount: 2500, period: 1).ipmt
    #   #=> -17.166666666666668
    #
    # @see http://www.oasis-open.org/committees/documents.php?wg_abbrev=office-formulaOpenDocument-formula-20090508.odt
    # @see [WRW] Wheeler, D. A., E. Rathke, and R. Weir (Eds.) (2009, May).
    #   Open Document Format for Office Applications (OpenDocument)v1.2,
    #   Part 2: Recalculated Formula (OpenFormula) Format - Annotated Version,
    #   Pre-Draft 12. Organization for the Advancement of Structured Information
    #   Standards (OASIS). Billerica, MA, USA. [ODT Document].
    def ipmt
      raise ArgumentError, 'no period given' if period.nil?

      ipmt_val = remaining_balance * monthly_rate
      if ptype == PAYMENT_TYPE_MAPPING[:beginning]
        period == 1 ? 0.0 : (ipmt_val / 1 + monthly_rate)
      else
        ipmt_val
      end
    end

    # PPmt computes principal payment for a loan under a given period.
    #
    #   Required Loan arguments: period, nominal_rate, duration, amount, future_value*
    #
    # @return [Float] Principal payment for a loan under a given period.
    #
    # @example
    #   require 'finance_rb'
    #   Finance::Loan.new(nominal_rate: 0.0824, duration: 12, amount: 2500, period: 1).ppmt
    #   #=> -200.58192368678277
    #
    # @see http://www.oasis-open.org/committees/documents.php?wg_abbrev=office-formulaOpenDocument-formula-20090508.odt
    # @see [WRW] Wheeler, D. A., E. Rathke, and R. Weir (Eds.) (2009, May).
    #   Open Document Format for Office Applications (OpenDocument)v1.2,
    #   Part 2: Recalculated Formula (OpenFormula) Format - Annotated Version,
    #   Pre-Draft 12. Organization for the Advancement of Structured Information
    #   Standards (OASIS). Billerica, MA, USA. [ODT Document].
    def ppmt
      pmt - ipmt
    end

    # Nper computes the number of periodic payments.
    #
    #   Required Loan arguments: payment, nominal_rate, period, amount, future_value*
    #
    # @return [Float] Number of periodic payments.
    #
    # @example
    #   require 'finance_rb'
    #   Finance::Loan.new(nominal_rate: 0.07, amount: 8000, payment: -150).nper
    #   #=> 64.0733487706618586
    def nper
      z = payment * (1.0 + monthly_rate * ptype) / monthly_rate

      Math.log(-future_value + z / (amount + z)) / Math.log(1.0 + monthly_rate)
    end

    # Fv computes future value at the end of some periods (duration).
    #   Required Loan arguments: nominal_rate, duration, payment, amount*
    #
    # @param payment [Float] The (fixed) periodic payment.
    #   In case you don't want to modify the original loan, use this parameter to recalculate fv.
    #
    # @return [Float] The value at the end of the `duration` periods.
    #
    # @example
    #   require 'finance_rb'
    #   Finance::Loan.new(nominal_rate: 0.05, duration: 120, amount: -100, payment: -200).fv
    #   #=> 15692.928894335748
    #
    # @see http://www.oasis-open.org/committees/documents.php?wg_abbrev=office-formulaOpenDocument-formula-20090508.odt
    # @see [WRW] Wheeler, D. A., E. Rathke, and R. Weir (Eds.) (2009, May).
    #   Open Document Format for Office Applications (OpenDocument)v1.2,
    #   Part 2: Recalculated Formula (OpenFormula) Format - Annotated Version,
    #   Pre-Draft 12. Organization for the Advancement of Structured Information
    #   Standards (OASIS). Billerica, MA, USA. [ODT Document].
    def fv(payment: nil)
      raise ArgumentError, 'no payment given' if self.payment.nil? && payment.nil?

      final_payment = payment || self.payment

      factor = (1.0 + monthly_rate)**duration
      second_factor = (factor - 1) * (1 + monthly_rate * ptype) / monthly_rate

      -((amount * factor) + (final_payment.to_f * second_factor))
    end

    private

    def initialize_payment_type(ptype)
      @ptype =
        if ptype.nil? || !PAYMENT_TYPE_MAPPING.keys.include?(ptype)
          PAYMENT_TYPE_MAPPING[:end]
        else
          PAYMENT_TYPE_MAPPING[ptype]
        end
    end

    def remaining_balance
      self.class.new(
        nominal_rate: nominal_rate.to_f, duration: period - 1.0,
        amount: amount.to_f, ptype: PAYMENT_TYPE_MAPPING.key(ptype)
      ).fv(payment: pmt)
    end
  end
end
