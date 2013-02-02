require 'shooting_stats/data_source/invalid_data_source_exception'

module ShootingStats
  module DataSource
    def self.from_file(file_path, file_type=nil)
      unless File.exists? file_path
        raise InvalidDataSourceException, "File not found: #{file_path}"
      end

      if file_type.nil?
        if file_path =~ /\.mlq/
          file_type = "megalink"
        else
          raise InvalidDataSourceException, "Can't auto-detect file type."
        end
      end

      case file_type
        when "megalink"
          require "shooting_stats/data_source/megalink"
          ShootingStats::DataSource::Megalink.new(file_path)
        else
          raise InvalidDataSourceException, "Unknown file type #{file_type}"
      end
    end
  end
end
