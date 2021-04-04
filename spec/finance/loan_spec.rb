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

  describe '#fv' do
    context 'with loan arguments' do
      it 'calculates correct fv value' do
        loan = Finance::Loan.new(nominal_rate: 0.05, duration: 120, amount: -100, payment: -100)
        expect(loan.fv).to eq(15_692.928894335748)
      end

      context 'with :ptype' do
        it 'calculates correct fv value' do
          loan = Finance::Loan.new(
            nominal_rate: 0.9, duration: 20, amount: 0, payment: -2000, ptype: :beginning
          )
          expect(loan.fv).to eq(93_105.06487352113)
        end
      end
    end

    context 'with an optional :payment argument' do
      it 'calculates correct fv value' do
        loan = Finance::Loan.new(nominal_rate: 0.05, duration: 120, amount: -100, payment: -200)
        expect(loan.fv(payment: -100)).to eq(15_692.928894335748)
      end
    end

    context 'w/o any payments' do
      it 'raises an ArgumentError exception w/o loan arguments' do
        loan = Finance::Loan.new(nominal_rate: 0.05, duration: 120, amount: -100)
        expect { loan.fv }.to raise_error(ArgumentError, "no payment given")
      end
    end
  end

  describe '#ipmt' do
    context 'when 1 period' do
      it 'calculates correct ipmt value' do
        loan = Finance::Loan.new(
          nominal_rate: 0.0824, duration: 12, amount: 2500, period: 1
        )
        expect(loan.ipmt).to eq(-17.166666666666668)
      end
    end

    context 'when 2 periods' do
      it 'calculates correct ipmt value' do
        loan = Finance::Loan.new(
          nominal_rate: 0.0824, duration: 12, amount: 2500, period: 2
        )
        expect(loan.ipmt).to eq(-15.789337457350777)
      end
    end

    context 'when 3 periods' do
      it 'calculates correct ipmt value' do
        loan = Finance::Loan.new(
          nominal_rate: 0.0824, duration: 12.0, amount: 2500.0, period: 3.0, fv: 0.0
        )
        expect(loan.ipmt).to eq(-14.402550587464257)
      end
    end
  end
end
