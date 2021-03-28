# frozen_string_literal: true

module Finance
  class Loan
    PAYMENT_TYPE_MAPPING = { end: 0, beginning: 1 }.freeze

    # @return [Float] The amount of loan request (I.e. a present value)
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
    #   Defaults to 0.
    attr_accessor :future_value

    def initialize(**options)
      initialize_payment_type(options[:ptype])
      @nominal_rate  = options.fetch(:nominal_rate, 0).to_f
      @duration      = options.fetch(:duration, 1).to_f
      @amount        = options.fetch(:amount, 0).to_f
      @future_value  = options.fetch(:future_value, 0).to_f
      @monthly_rate = @nominal_rate / 12
    end

    # Pmt computes the payment against a loan principal plus interest (future_value = 0).
    #   It can also be used to calculate the recurring payments needed to achieve
    #   a certain future value given an initial deposit,
    #   a fixed periodically compounded interest rate, and the total number of periods.
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

      (-future_value + amount * factor) / second_factor
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
  end
end
