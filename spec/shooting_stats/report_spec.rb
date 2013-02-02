require "spec_helper"

require "shooting_stats/report"
require "shooting_stats/report/invalid_report_exception"

describe ShootingStats::Report do
  describe ".from_name" do
    describe "when given a valid name" do
      it "should return an instance of that report class" do
        list_report = nil
        expect {
          list_report = ShootingStats::Report.from_name('list')
        }.to_not raise_error
        list_report.should_not be_nil
        list_report.should be_a_kind_of(ShootingStats::Report::List)
      end
    end

    describe "when given an invalid name" do
      it "should raise an error" do
        expect {
          ShootingStats::Report.from_name('bad-report-name')
        }.to raise_error ShootingStats::Report::InvalidReportException
      end
    end

    describe "when given a valid name of a report which does not exist" do
      it "should raise an error" do
        expect {
          ShootingStats::Report.from_name('does_not_exist')
        }.to raise_error ShootingStats::Report::InvalidReportException
      end
    end
  end

  describe ".report_class_name" do
    data = {
        :Foo => "Foo",
        :foo => "Foo",
        :foo_bar => "FooBar",
        :FooBar => "FooBar",
    }

    data.each_pair do |report_name, class_name|
      it "should generate #{class_name} from '#{report_name}'" do
        rc = ShootingStats::Report.report_class_name(report_name.to_s)
        rc.should == class_name
      end
    end

    it "should fail when given 'foo-bar'" do
      expect {
        ShootingStats::Report.report_class_name('foo-bar')
      }.to raise_error ShootingStats::Report::InvalidReportException
    end
  end

  describe ".report_dir" do
    it "should return a directory which exists" do
      File.exists?(ShootingStats::Report.report_dir).should be_true
      File.directory?(ShootingStats::Report.report_dir).should be_true
    end
  end

  describe ".report_file_name" do
    data = {
      :Foo => "foo.rb",
      :foo => "foo.rb",
      :foo_bar => "foo_bar.rb",
      :FooBar => "foo_bar.rb",
    }

    data.each_pair do |report_name, file_name|
      it "should generate #{file_name} from '#{report_name}'" do
        rfn = ShootingStats::Report.report_file_name(report_name.to_s)
        rfn.should == file_name
      end
    end

    it "should fail when given 'foo-bar'" do
      expect {
        ShootingStats::Report.report_file_name('foo-bar')
      }.to raise_error ShootingStats::Report::InvalidReportException
    end
  end
end
