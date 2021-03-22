require 'spec_helper'

RSpec.describe Finance::Calculations do
  describe '#npv' do
    it 'calculates correct npv value' do
      expect(Finance::Calculations.npv(0.2, [-1000, 100, 100, 100])).to eq(-789.3518518518517)
    end

    it 'is available through alias name' do
      expect(
        Finance::Calculations.net_present_value(0.1, [-100, 6, 6, 6])
      ).to eq(-85.07888805409468)
    end

    it 'calculates correct npv for zero rates' do
      expect(
        Finance::Calculations.net_present_value(0.0, [-2000, 55, 55, 55])
      ).to eq(-1835.0)
    end
  end

  describe '#irr' do
    it 'calculates correct irr value' do
      expect(
        Finance::Calculations.irr([-4000,1200,1410,1875,1050])
      ).to eq(0.14299344106053188)
    end

    it 'calculates zero value for cashflows w/o any inflows' do
      expect(
        Finance::Calculations.irr([100,500,200,50])
      ).to eq(0.0)
    end

    it 'is available through alias name' do
      expect(
        Finance::Calculations.internal_return_rate([-100, 0, 0, 74])
      ).to eq(-0.09549583035161031)
    end
  end
end