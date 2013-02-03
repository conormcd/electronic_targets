require 'optparse'

require 'shooting_stats/data_source'
require 'shooting_stats/report'

module ShootingStats
  # Main entry point for running the analyses.
  class Runner
    attr_accessor :help_message
    attr_accessor :input_file
    attr_accessor :input_file_type
    attr_accessor :report_names

    def initialize(args=nil)
      @report_names = []

      configure_from(args) if args
    end

    def configure_from!(args)
      option_parser = OptionParser.new do |opts|
        opts.banner += ' input_file report_name [report_name...]'
        opts.on('-t', '--type=TYPE', 'The type of the input file') do |t|
          @input_file_type = t
        end
      end
      @help_message = option_parser.to_s
      option_parser.parse!(args)

      @input_file = args.shift
      if @input_file.nil?
        raise OptionParser::MissingArgument.new('input_file')
      end
      @report_names += args
      if @report_names.empty?
        raise OptionParser::MissingArgument.new('report_name')
      end
    end

    def run!
      source = DataSource.from_file(input_file, input_file_type)
      report_names.each do |report_name|
        report = Report.from_name(report_name)
        report.generate_from(source)
      end
    end
  end
end
