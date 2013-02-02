require "spec_helper"

require "shooting_stats/model/card"
require "shooting_stats/model/invalid_data_exception"

describe ShootingStats::Model::Card do
  describe "#initialize" do
    it "should be possible to set the name from an initializer block" do
      card = nil
      expect {
        card = ShootingStats::Model::Card.new do |c|
          c.name = "Card Name"
        end
      }.to_not raise_error ShootingStats::Model::InvalidDataException
      card.should_not be_nil
      card.name.should == "Card Name"
    end
  end
end