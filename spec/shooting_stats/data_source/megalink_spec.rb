require "spec_helper"

require "shooting_stats/data_source/megalink"
require "shooting_stats/model/card"
require "shooting_stats/model/target"
require "shooting_stats/model/invalid_data_exception"

def fixtures
  SpecHelper::Fixtures::DataSource::Megalink.new
end

describe ShootingStats::DataSource::Megalink do
  def new_megalink(*args)
    ShootingStats::DataSource::Megalink.new(*args)
  end

  before do
    @megalink = new_megalink
  end

  describe "should load from" do
    if fixtures.mlq.count > 0
      fixtures.mlq.each_pair do |name, path|
        it name do
          expect { new_megalink(path) }.to_not raise_error
        end
      end
    else
      it "MLQ files which were not found" do
        fail
      end
    end
  end

  describe '#db' do
    describe 'with a valid MLQ' do
      before do
        @megalink = new_megalink(fixtures.mlq.first[1])
      end

      it 'should return a Sequel::SQLite::Database object' do
        @megalink.db.should be_a_kind_of(Sequel::SQLite::Database)
      end

      it 'should cache creation of the Sequel object' do
        @megalink.db.object_id.should == @megalink.db.object_id
      end
    end

    describe 'with no MLQ' do
      it "should raise an exception" do
        expect { @megalink.shots }.to raise_error
      end
    end

    describe 'with a path to a nonexistant MLQ' do
      before do
        @megalink = new_megalink("/does/not/exist")
      end

      it "should raise an exception" do
        expect { @megalink.shots }.to raise_error
      end
    end
  end

  describe '#params' do
    fixtures.mlq.each_pair do |name, path|
      describe "after loading #{name}" do
        before do
          @megalink = new_megalink(path)
        end

        it 'should return a Hash' do
          @megalink.params.should be_a_kind_of(Hash)
        end

        it 'should cache the creation of the Hash' do
          @megalink.params.object_id.should == @megalink.params.object_id
        end

        [:DistanceActual, :DistanceSimulated, :TargetID].each do |param|
          it "should contain a value for #{param}" do
            @megalink.params.should include(param)
            @megalink.params[param].should be_a_kind_of(Fixnum)
          end
        end
      end
    end
  end

  describe "#shots" do
    fixtures.mlq.each_pair do |name, path|
      describe "after loading #{name}" do
        before do
          @megalink = new_megalink(path)
        end

        it "should return a list of shots" do
          @megalink.shots.should have_at_least(0).items
        end

        it "should only return valid shots" do
          expect {
            @megalink.shots
          }.to_not raise_error ShootingStats::Model::InvalidDataException
        end

        it "should return shots with a monotonically increasing time value" do
          last_time = -1
          @megalink.shots.each do |shot|
            shot.time.should be > last_time
            last_time = shot.time
          end
        end

        it "should only return shots with scores between 0 and 10.9" do
          @megalink.shots.each do |shot|
            shot.score.should be >= 0
            shot.score.should be <= 10.9
          end
        end
      end
    end
  end

  describe '#target' do
    fixtures.mlq.each_pair do |name, path|
      describe "after loading #{name}" do
        before do
          @megalink = new_megalink(path)
        end

        it 'should return an instance of ShootingStats::Model::Target' do
          @megalink.target.should be_a_kind_of(
            ShootingStats::Model::Target::Base
          )
        end
      end
    end

    describe 'with an MLQ containing an unknown target' do
      it 'should raise an exception' do
        @megalink.stub(:params).and_return({:TargetID => 666})
        expect { @megalink.target }.to raise_error
      end
    end
  end

  describe '#scaling_factor' do
    fixtures.mlq.each_pair do |name, path|
      describe "after loading #{name}" do
        before do
          @megalink = new_megalink(path)
        end

        it 'should be a Float >= 1.0' do
          @megalink.scaling_factor.should be_a_kind_of(Float)
          @megalink.scaling_factor.should be >= 1.0
        end
      end
    end
  end
end
