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
      expect(megalink.db).to be_a_kind_of(Sequel::SQLite::Database)
    end

    it 'caches creation of the Sequel object' do
      expect(megalink.db.object_id).to eq(megalink.db.object_id)
    end
  end

  describe '#params' do
    it 'returns a Hash' do
      expect(megalink.params).to be_a_kind_of(Hash)
    end

    it 'caches the creation of the Hash' do
      expect(megalink.params.object_id).to eq(megalink.params.object_id)
    end

    [:DistanceActual, :DistanceSimulated, :TargetID].each do |param|
      it "contains a value for #{param}" do
        expect(megalink.params).to include(param)
        expect(megalink.params[param]).to be_a_kind_of(Fixnum)
      end
    end
  end

  describe "#shots" do
    it "returns a list of shots" do
      expect(megalink.shots).to_not be_empty
    end

    it "only returns valid shots" do
      expect {
        megalink.shots
      }.to_not raise_error
    end

    it "returns shots with a monotonically increasing time value" do
      last_time = -1
      megalink.shots.each do |shot|
        expect(shot.time).to be > last_time
        last_time = shot.time
      end
    end

    it "returns shots with scores between 0 and 10.9" do
      megalink.shots.each do |shot|
        expect(shot.score).to be >= 0
        expect(shot.score).to be <= 10.9
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
        expect(megalink.target).to be_a_kind_of(
          ElectronicTargets::Model::Target::Base
        )
      end
    end

    context 'with an MLQ referencing an unknown target' do
      it 'raises an exception' do
        allow(megalink).to receive(:params).and_return({:TargetID => 666})
        expect { megalink.target }.to raise_error
      end
    end
  end

  describe '#scaling_factor' do
    it 'is a Float >= 1.0' do
      expect(megalink.scaling_factor).to be_a_kind_of(Float)
      expect(megalink.scaling_factor).to be >= 1.0
    end
  end
end
