require 'spec_helper'

describe ElectronicTargets::Model::Shot do
  let(:shot) {
    ElectronicTargets::Model::Shot.new do |s|
      shot_data.each_pair do |k, v|
        s.send "#{k}=", v
      end
    end
  }
  let(:shot_data) { good_shot_data }
  let(:good_shot_data) {
    {
      :horizontal_error => 0,
      :vertical_error => 0,
      :time => 0,
      :target => ElectronicTargets::Model::Target::ISSF50mRifle.instance,
      :series => 2
    }
  }

  describe "#initialize" do
    shared_examples_for 'an invalid initialize' do
      it 'raises an ArgumentError' do
        expect { shot }.to raise_error ArgumentError
      end
    end

    context 'when good shot data is provided' do
      it 'does not raise an ArgumentError' do
        expect { shot }.to_not raise_error
      end
    end

    context 'when no horizontal error is provided' do
      it_behaves_like 'an invalid initialize' do
        let(:shot_data) { good_shot_data.reject{|k, v| k == :horizontal_error} }
      end
    end

    context 'when no vertical error is provided' do
      it_behaves_like 'an invalid initialize' do
        let(:shot_data) { good_shot_data.reject{|k, v| k == :vertical_error} }
      end
    end

    context 'when no time is provided' do
      it_behaves_like 'an invalid initialize' do
        let(:shot_data) { good_shot_data.reject{|k, v| k == :time} }
      end
    end

    context 'when a negative time is provided' do
      it_behaves_like 'an invalid initialize' do
        let(:shot_data) { good_shot_data.merge({:time => -1}) }
      end
    end

    context 'when no target type is provided' do
      it_behaves_like 'an invalid initialize' do
        let(:shot_data) { good_shot_data.reject{|k, v| k == :target} }
      end
    end

    context 'when no series number is provided' do
      it_behaves_like 'an invalid initialize' do
        let(:shot_data) { good_shot_data.reject{|k, v| k == :series} }
      end
    end
  end

  describe "#sighter?" do
    context "when the shot is a sighting shot" do
      let(:shot_data) { good_shot_data.merge({:series => 1}) }

      it 'should be true' do
        shot.should be_sighter
      end
    end

    context "when the shot is a match shot" do
      it 'should not be true' do
        shot.should_not be_sighter
      end
    end
  end

  describe "#score" do
    it "should be a positive float" do
      shot.score.should be >= 0
      shot.score.should be_a_kind_of(Float)
    end
  end

  describe "#time" do
    context 'when given a format' do
      it 'returns the time formatted according to the given format string' do
        shot.time('%Y-%m-%d %H:%M:%S').should == "1970-01-01 00:00:00"
      end
    end

    context 'when given no format' do
      it 'returns the time as a UNIX epoch time' do
        shot.time.should be_a_kind_of(Fixnum)
      end
    end
  end

  describe "#to_f" do
    it "returns a positive float" do
      shot.to_f.should be >= 0
      shot.to_f.should be_a_kind_of(Float)
    end
  end

  describe "#to_i" do
    it "returns a positive integer" do
      shot.to_i.should be >= 0
      shot.to_i.should be_a_kind_of(Fixnum)
    end
  end
end
