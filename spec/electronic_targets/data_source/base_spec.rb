require "spec_helper"

describe ElectronicTargets::DataSource::Base do
  describe '#shots' do
    it 'should raise an exception if called directly' do
      expect { ElectronicTargets::DataSource::Base.new.shots }.to raise_error
    end
  end

  describe '#sighting_shots' do
    let(:data_source) {
      ElectronicTargets::DataSource::Megalink.new(megalink_fixtures.mlq.first[1])
    }

    it 'returns some shots' do
      expect(data_source.sighting_shots).not_to be_empty
    end

    it 'returns only sighting shots' do
      data_source.sighting_shots.each do |shot|
        expect(shot).to be_sighter
      end
    end
  end

  describe '#match_shots' do
    let(:data_source) {
      ElectronicTargets::DataSource::Megalink.new(megalink_fixtures.mlq.first[1])
    }

    it 'returns some shots' do
      expect(data_source.match_shots).not_to be_empty
    end

    it 'does not return sighting shots' do
      data_source.match_shots.each do |shot|
        expect(shot).not_to be_sighter
      end
    end
  end
end
