require "spec_helper"

describe ElectronicTargets::Model::Target do
  let(:shot) {
    ElectronicTargets::Model::Shot.new do |shot|
      shot.time = Time.now.to_i
      shot.horizontal_error = 0
      shot.vertical_error = 0
      shot.target = target
    end
  }

  describe ElectronicTargets::Model::Target::Base do
    let(:target) { ElectronicTargets::Model::Target::Base.instance }

    describe '#score' do
      it 'should raise an error' do
        expect { target.score(0, 0) }.to raise_error NotImplementedError
      end
    end
  end

  describe ElectronicTargets::Model::Target::RingTarget do
    let(:target) { ElectronicTargets::Model::Target::RingTarget.instance }

    describe '#score' do
      it 'should be able to calculate non-decimal scores' do
        target.stub(:max_score).and_return(10)
        target.stub(:ring_size).and_return(8)
        target.score(shot).should == 10
      end

      it 'should be able to calculate scores to multiple decimal places' do
        shot.stub(:horizontal_error).and_return(4.30)
        shot.stub(:vertical_error).and_return(2.01)
        target.stub(:decimal_places).and_return(2)
        target.stub(:max_score).and_return(10.9)
        target.stub(:ring_size).and_return(8)

        target.score(shot).should == 10.31
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
            shot.stub(:horizontal_error).and_return(args[0])
            shot.stub(:vertical_error).and_return(args[1])
            target.score(shot).should == score
          end
        end
      end
    end
  end

  describe ElectronicTargets::Model::Target::ISSF50mRifle do
    let(:target) { ElectronicTargets::Model::Target::ISSF50mRifle.instance }

    describe '#score' do
      it "should score 0, 0 as a 10.9" do
        target.score(shot).should == 10.9
      end

      it "should score 165, 165 as a 0" do
        shot.stub(:horizontal_error).and_return(165)
        shot.stub(:vertical_error).and_return(165)
        target.score(shot).should == 0
      end

      it "should agree with all the scores in the Megalink precomputed set" do
        megalink_fixtures.precomputed.each do |_, data|
          data.each do |precomp_shot|
            shot.stub(:horizontal_error).and_return(precomp_shot[:Horizontal])
            shot.stub(:vertical_error).and_return(precomp_shot[:Vertical])

            target.score(shot).should == precomp_shot[:Score]
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
          shot.stub(:horizontal_error).and_return(args[0])
          shot.stub(:vertical_error).and_return(args[1])
          target.score(shot).should == score
        end
      end
    end
  end
end
