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
      data_source.sighting_shots.count.should be > 0
    end

    it 'returns only sighting shots' do
      data_source.sighting_shots.each do |shot|
        shot.should be_sighter
      end
    end
  end

  describe '#match_shots' do
    let(:data_source) {
      ElectronicTargets::DataSource::Megalink.new(megalink_fixtures.mlq.first[1])
    }

    it 'returns some shots' do
      data_source.match_shots.count.should be > 0
    end

    it 'does not return sighting shots' do
      data_source.match_shots.each do |shot|
        shot.should_not be_sighter
      end
    end
  end
end
