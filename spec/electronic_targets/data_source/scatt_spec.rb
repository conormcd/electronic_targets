require "spec_helper"

describe ElectronicTargets::DataSource::SCATT do
  let(:scatt_file) { scatt_fixtures.scatt.first[1] }
  let(:scatt) { ElectronicTargets::DataSource::SCATT.new(scatt_file) }

  describe '#initialize' do
    context 'with a valid SCATT file' do
      it 'does not raise an exception' do
        expect { scatt }.to_not raise_error
      end
    end

    context 'with no SCATT file' do
      let(:scatt_file) { nil }

      it 'raises an exception' do
        expect { scatt }.to raise_error
      end
    end

    context 'with a path to a nonexistant SCATT file' do
      let(:scatt_file) { '/does/not/exist' }

      it 'raises an exception' do
        expect { scatt }.to raise_error
      end
    end
  end

  describe '#shots' do
    it 'returns a list of shots' do
      expect(scatt.shots).to have_at_least(0).items
    end

    it "only returns valid shots" do
      expect {
        scatt.shots
      }.to_not raise_error
    end

    it "returns shots with a monotonically increasing time value" do
      last_time = -1
      scatt.shots.each do |shot|
        expect(shot.time).to be > last_time
        last_time = shot.time
      end
    end

    it "returns shots with scores between 0 and 10.9" do
      scatt.shots.each do |shot|
        expect(shot.score).to be >= 0
        expect(shot.score).to be <= 10.9
      end
    end

    it 'does not raise an exception for any of the fixture SCATTs' do
      scatt_fixtures.scatt.each_pair do |name, file|
        expect {
          ElectronicTargets::DataSource::SCATT.new(file).shots
        }.to_not raise_error
      end
    end
  end

  describe '#target' do
    context 'with a SCATT file referencing a known target' do
      xit 'returns an instance of ElectronicTargets::Model::Target' do
        scatt.target.should be_a_kind_of(
          ElectronicTargets::Model::Target::Base
        )
      end
    end

    context 'with a SCATT file referencing an unknown target' do
      it 'raises an exception' do
        allow(scatt).to receive(:params).and_return({:TargetID => 666})
        expect { scatt.target }.to raise_error
      end
    end
  end
end
