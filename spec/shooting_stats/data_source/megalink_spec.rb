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

  describe "#shots" do
    it "should fail if no path was given in #initialize" do
      expect { @megalink.shots }.to raise_error
    end

    it "should fail if the path give in #initialize does not point to a file" do
      @megalink = new_megalink("/does/not/exist")
      expect { @megalink.shots }.to raise_error
    end

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
end
