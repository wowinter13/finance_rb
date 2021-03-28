require 'spec_helper'

RSpec.describe Finance::Loan do
  describe '#pmt' do
    context 'w/o a full set of params' do
      it 'calculates correct pmt value w/o :ptype' do
        loan = Finance::Loan.new(nominal_rate: 0.1, duration: 12, amount: 1000)
        expect(loan.pmt).to eq(87.9158872300099)
      end

      it 'calculates correct pmt value w/o :nominal_rate' do
        loan = Finance::Loan.new(duration: 12, amount: 1200, ptype: :end)
        expect(loan.pmt).to eq(100)
      end
    end

    context 'with zero rates' do
      it 'calculates correct pmt value for 3 years' do
        loan = Finance::Loan.new(nominal_rate: 0, duration: 36, amount: 10_000, ptype: :end)
        expect(loan.pmt).to eq(277.77777777777777)
      end

      it 'calculates correct pmt value for 6 months' do
        loan = Finance::Loan.new(nominal_rate: 0, duration: 6, amount: 10_000, ptype: :end)
        expect(loan.pmt).to eq(1666.6666666666667)
      end
    end

    context 'with :beginning ptype' do
      it 'calculates correct pmt value' do
        loan = Finance::Loan.new(nominal_rate: 0.12, duration: 6, amount: 1000, ptype: :beginning)
        expect(loan.pmt).to eq(170.8399670404763)
      end
    end

    it 'calculates correct pmt value' do
      loan = Finance::Loan.new(nominal_rate: 0.13, duration: 90, amount: 1_000_000, ptype: :end)
      expect(loan.pmt).to eq(17_449.90775727763)
    end
  end
end
