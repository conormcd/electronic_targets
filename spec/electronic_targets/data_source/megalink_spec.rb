require "spec_helper"

describe ElectronicTargets::DataSource::Megalink do
  let(:mlq) { megalink_fixtures.mlq.first[1] }
  let(:megalink) { ElectronicTargets::DataSource::Megalink.new(mlq) }

  describe '#initialize' do
    context 'with a valid MLQ' do
      it 'does not raise an exception' do
        expect { megalink }.to_not raise_error
      end
    end

    context 'with no MLQ' do
      let(:mlq) { nil }

      it 'raises an exception' do
        expect { megalink }.to raise_error
      end
    end

    context 'with a path to a nonexistant MLQ' do
      let(:mlq) { '/does/not/exist' }

      it "raises an exception" do
        expect { megalink }.to raise_error
      end
    end
  end

  describe '#db' do
    it 'returns a Sequel::SQLite::Database object' do
      megalink.db.should be_a_kind_of(Sequel::SQLite::Database)
    end

    it 'caches creation of the Sequel object' do
      megalink.db.object_id.should == megalink.db.object_id
    end
  end

  describe '#params' do
    it 'returns a Hash' do
      megalink.params.should be_a_kind_of(Hash)
    end

    it 'caches the creation of the Hash' do
      megalink.params.object_id.should == megalink.params.object_id
    end

    [:DistanceActual, :DistanceSimulated, :TargetID].each do |param|
      it "contains a value for #{param}" do
        megalink.params.should include(param)
        megalink.params[param].should be_a_kind_of(Fixnum)
      end
    end
  end

  describe "#shots" do
    it "returns a list of shots" do
      megalink.shots.should have_at_least(0).items
    end

    it "only returns valid shots" do
      expect {
        megalink.shots
      }.to_not raise_error
    end

    it "returns shots with a monotonically increasing time value" do
      last_time = -1
      megalink.shots.each do |shot|
        shot.time.should be > last_time
        last_time = shot.time
      end
    end

    it "returns shots with scores between 0 and 10.9" do
      megalink.shots.each do |shot|
        shot.score.should be >= 0
        shot.score.should be <= 10.9
      end
    end

    it 'does not raise an exception for any of the fixture MLQs' do
      megalink_fixtures.mlq.each_pair do |name, mlq|
        expect {
          ElectronicTargets::DataSource::Megalink.new(mlq).shots
        }.to_not raise_error
      end
    end
  end

  describe '#target' do
    context 'with an MLQ referencing a known target' do
      it 'returns an instance of ElectronicTargets::Model::Target' do
        megalink.target.should be_a_kind_of(
          ElectronicTargets::Model::Target::Base
        )
      end
    end

    context 'with an MLQ referencing an unknown target' do
      it 'raises an exception' do
        megalink.stub(:params).and_return({:TargetID => 666})
        expect { megalink.target }.to raise_error
      end
    end
  end

  describe '#scaling_factor' do
    it 'is a Float >= 1.0' do
      megalink.scaling_factor.should be_a_kind_of(Float)
      megalink.scaling_factor.should be >= 1.0
    end
  end
end
