require "spec_helper"

describe ElectronicTargets::Model::Card do
  describe "#initialize" do
    it "should be possible to set the name from an initializer block" do
      card = nil
      expect {
        card = ElectronicTargets::Model::Card.new do |c|
          c.name = "Card Name"
        end
      }.to_not raise_error ArgumentError
      card.should_not be_nil
      card.name.should == "Card Name"
    end
  end
end
