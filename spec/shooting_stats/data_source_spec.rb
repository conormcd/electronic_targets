require "spec_helper"

require "shooting_stats/data_source"
require "shooting_stats/data_source/invalid_data_source_exception"

describe ShootingStats::DataSource do
  describe ".from_file" do
    before do
      @megalink_fixtures = SpecHelper::Fixtures::DataSource::Megalink.new
    end

    it "should fail when given a bad file name" do
      expect {
        ShootingStats::DataSource.from_file('/does/not/exist', 'megalink')
      }.to raise_error ShootingStats::DataSource::InvalidDataSourceException
    end

    it "should be able to guess the file type from the file name" do
      @megalink_fixtures.mlq_files.each do |path|
        ds = ShootingStats::DataSource.from_file(path)
        ds.should be_a_kind_of(ShootingStats::DataSource::Megalink)
      end
    end

    it "should fail when it can't guess the file type" do
      @megalink_fixtures.precomputed_files.each do |path|
        expect {
          ShootingStats::DataSource.from_file(path)
        }.to raise_error ShootingStats::DataSource::InvalidDataSourceException
      end
    end

    it "should fail when it's given a bad file type" do
      @megalink_fixtures.mlq_files.each do |path|
        expect {
          ShootingStats::DataSource.from_file(path, 'not-megalink')
        }.to raise_error ShootingStats::DataSource::InvalidDataSourceException
      end
    end
  end
end