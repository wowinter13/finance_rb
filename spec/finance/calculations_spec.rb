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

    it 'returns correct npv for zero rates' do
      expect(
        Finance::Calculations.net_present_value(0.0, [-2000, 55, 55, 55])
      ).to eq(-1835.0)
    end
  end
end