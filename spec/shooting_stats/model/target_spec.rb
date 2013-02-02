require "spec_helper"

require "shooting_stats/model/target"

describe ShootingStats::Model::Target do
  describe ShootingStats::Model::Target::Base do
    before do
      @target = ShootingStats::Model::Target::Base.instance
    end

    describe '#score' do
      it 'should raise an error' do
        expect { @target.score(0, 0) }.to raise_error NotImplementedError
      end
    end

    describe '#radius' do
      it '0, 0 -> 0' do
        @target.radius(0, 0).should == 0
      end

      it '3, 4 -> 5' do
        @target.radius(3, 4).should == 5
      end
    end
  end

  describe ShootingStats::Model::Target::RingTarget do
    before do
      @target = ShootingStats::Model::Target::RingTarget.instance
    end

    describe '#score' do
      it 'should be able to calculate non-decimal scores' do
        @target.stub(:max_score).and_return(10)
        @target.stub(:ring_size).and_return(8)
        @target.score(0, 0).should == 10
      end

      it 'should be able to calculate scores to multiple decimal places' do
        @target.stub(:decimal_places).and_return(2)
        @target.stub(:max_score).and_return(10.9)
        @target.stub(:ring_size).and_return(8)
        @target.score(4.30, 2.01).should == 10.31
      end

      describe 'when outward gauging' do
        before do
          # Set it up like an NSRA 25yd target
          @target.stub(:decimal_places).and_return(0)
          @target.stub(:max_score).and_return(10)
          @target.stub(:ring_size).and_return(3.66)
        end

        it '0, 0 -> 10' do
          @target.score(0, 0).should == 10
        end

        it '3.5, 0 -> 10' do
          @target.score(3.5, 0).should == 10
        end

        it '7.3, 0 -> 10' do
          @target.score(7.3, 0).should == 9
        end

        it '7.4, 0 -> 10' do
          @target.score(7.4, 0).should == 8
        end
      end
    end
  end

  describe ShootingStats::Model::Target::ISSF50mRifle do
    before do
      @target = ShootingStats::Model::Target::ISSF50mRifle.instance
    end

    describe '#score' do
      it "should score 0, 0 as a 10.9" do
        @target.score(0, 0).should == 10.9
      end

      it "should score 165, 165 as a 0" do
        @target.score(165, 165).should == 0
      end

      it "should agree with all the scores in the Megalink precomputed set" do
        pre_comp = SpecHelper::Fixtures::DataSource::Megalink.new.precomputed
        pre_comp.each do |_, data|
          data.each do |shot|
            score = @target.score(shot[:Horizontal], shot[:Vertical])
            score.should == shot[:Score]
          end
        end
      end
    end
  end
end
