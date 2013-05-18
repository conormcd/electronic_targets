require "spec_helper"

describe ElectronicTargets::Model::Target do
  describe ElectronicTargets::Model::Target::Base do
    let(:target) { ElectronicTargets::Model::Target::Base.instance }

    describe '#score' do
      it 'should raise an error' do
        expect { target.score(0, 0) }.to raise_error NotImplementedError
      end
    end

    describe '#radius' do
      it '0, 0 -> 0' do
        target.radius(0, 0).should == 0
      end

      it '3, 4 -> 5' do
        target.radius(3, 4).should == 5
      end
    end
  end

  describe ElectronicTargets::Model::Target::RingTarget do
    let(:target) { ElectronicTargets::Model::Target::RingTarget.instance }

    describe '#score' do
      it 'should be able to calculate non-decimal scores' do
        target.stub(:max_score).and_return(10)
        target.stub(:ring_size).and_return(8)
        target.score(0, 0).should == 10
      end

      it 'should be able to calculate scores to multiple decimal places' do
        target.stub(:decimal_places).and_return(2)
        target.stub(:max_score).and_return(10.9)
        target.stub(:ring_size).and_return(8)
        target.score(4.30, 2.01).should == 10.31
      end

      describe 'when outward gauging like an NSRA 25yd target' do
        before do
          target.stub(:decimal_places).and_return(0)
          target.stub(:max_score).and_return(10)
          target.stub(:ring_size).and_return(3.66)
        end

        {
          [0, 0] => 10,
          [3.5, 0] => 10,
          [7.3, 0] => 9,
          [7.4, 0] => 8,
        }.each_pair do |args, score|
          it "should score #{args.join(", ")} as a #{score}" do
            target.score(*args).should == score
          end
        end
      end
    end
  end

  describe ElectronicTargets::Model::Target::ISSF50mRifle do
    let(:target) { ElectronicTargets::Model::Target::ISSF50mRifle.instance }

    describe '#score' do
      it "should score 0, 0 as a 10.9" do
        target.score(0, 0).should == 10.9
      end

      it "should score 165, 165 as a 0" do
        target.score(165, 165).should == 0
      end

      it "should agree with all the scores in the Megalink precomputed set" do
        megalink_fixtures.precomputed.each do |_, data|
          data.each do |shot|
            score = target.score(shot[:Horizontal], shot[:Vertical])
            score.should == shot[:Score]
          end
        end
      end
    end
  end

  describe ElectronicTargets::Model::Target::ISSF10mRifle do
    let(:target) { ElectronicTargets::Model::Target::ISSF10mRifle.instance }

    describe '#score' do
      {
        [0, 0] => 10.9,
        [0.59, 0.30] => 10.7,
        [0.68, 0.11] => 10.7,
        [0.35, 2.47] => 10.0,
        [-0.82, 2.48] => 9.9,
        [-0.915, 0.915] => 10.4,
        [-1.72, 1.72] => 10.0,
        [-0.5, 0.5] => 10.7,
        [-0.85, 0.85] => 10.5,
        [-1.41, 1.41] => 10.2,
      }.each_pair do |args, score|
        it "should score #{args.join(", ")} as a #{score}" do
          target.score(*args).should == score
        end
      end
    end
  end
end
