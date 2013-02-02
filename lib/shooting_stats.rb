require 'shooting_stats/data_source'
require 'shooting_stats/report'

module ShootingStats
  # Main entry point for running the analyses.
  class Runner
    def initialize(report_names, input_file, input_file_type=nil)
      @report_names = report_names
      @input_file = input_file
      @input_file_type = input_file_type
    end

    def run!
      source = DataSource.from_file(@input_file, @input_file_type)
      @report_names.each do |report_name|
        report = Report.from_name(report_name)
        report.generate_from(source)
      end
    end
  end
end
