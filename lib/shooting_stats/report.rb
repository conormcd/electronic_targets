require "shooting_stats/report/invalid_report_exception"

module ShootingStats
  module Report
    CLASS_REGEX = /^(?:[A-Z][a-z0-9]*)+$/
    FILE_REGEX = /^[a-z][a-z_]*$/

    def self.from_name(report_name)
      path = File.expand_path(report_file_name(report_name), report_dir)
      unless File.exists?(path)
        message = "Report \"#{report_name}\" does not exist at #{path}"
        raise InvalidReportException, message
      end
      require path
      ShootingStats::Report.const_get(report_class_name(report_name)).new
    end

    def self.report_class_name(report_name)
      if report_name =~ CLASS_REGEX
        report_name
      elsif report_name =~ FILE_REGEX
        report_name.split('_').map {|w| w.capitalize}.join
      else
        raise InvalidReportException, "Malformed report name: #{report_name}"
      end
    end

    def self.report_dir
      File.expand_path('../report', __FILE__)
    end

    def self.report_file_name(report_name)
      if report_name =~ CLASS_REGEX
        words = []
        current_word = ""
        report_name.split(//).each do |letter|
          if letter =~ /[A-Z]/ && current_word != ""
            words << current_word
            current_word = ""
          end
          current_word += letter
        end
        words << current_word if current_word != ""
        file_name = words.map {|w| w.downcase}.join('_')
      elsif report_name =~ FILE_REGEX
        file_name = report_name
      else
        raise InvalidReportException, "Malformed report name: #{report_name}"
      end
      "#{file_name}.rb"
    end
  end
end
