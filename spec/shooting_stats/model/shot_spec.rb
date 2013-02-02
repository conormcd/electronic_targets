require 'spec_helper'

require 'shooting_stats/model/card'
require 'shooting_stats/model/shot'
require 'shooting_stats/model/target'
require 'shooting_stats/model/invalid_data_exception'

describe ShootingStats::Model::Shot do
  before do
    @shot = ShootingStats::Model::Shot.new do |s|
      s.vertical_error = 0
      s.horizontal_error = 0
      s.time = 0
      s.target = ShootingStats::Model::Target::ISSF50mRifle.instance
    end
  end

  describe "#initialize" do
    it "should raise an exception if no horizontal error is provided" do
      expect {
        ShootingStats::Model::Shot.new do |s|
          s.vertical_error = 0
          s.time = 0
          s.target = ShootingStats::Model::Target::ISSF50mRifle.instance
        end
      }.to raise_error ShootingStats::Model::InvalidDataException
    end

    it "should raise an exception if no vertical error is provided" do
      expect {
        ShootingStats::Model::Shot.new do |s|
          s.horizontal_error = 0
          s.time = 0
          s.target = ShootingStats::Model::Target::ISSF50mRifle.instance
        end
      }.to raise_error ShootingStats::Model::InvalidDataException
    end

    it "should raise an exception if no time is provided" do
      expect {
        ShootingStats::Model::Shot.new do |s|
          s.horizontal_error = 0
          s.vertical_error = 0
          s.target = ShootingStats::Model::Target::ISSF50mRifle.instance
        end
      }.to raise_error ShootingStats::Model::InvalidDataException
    end

    it "should raise an exception if a negative time is provided" do
      expect {
        ShootingStats::Model::Shot.new do |s|
          s.horizontal_error = 0
          s.vertical_error = 0
          s.time = -1
          s.target = ShootingStats::Model::Target::ISSF50mRifle.instance
        end
      }.to raise_error ShootingStats::Model::InvalidDataException
    end

    it "should raise an exception if no target type is provided" do
      expect {
        ShootingStats::Model::Shot.new do |s|
          s.horizontal_error = 0
          s.vertical_error = 0
          s.time = 0
        end
      }.to raise_error ShootingStats::Model::InvalidDataException
    end
  end

  describe "#shot" do
    it "should be a positive float" do
      @shot.score.should be >= 0
      @shot.score.should be_a_kind_of(Float)
    end
  end
end
