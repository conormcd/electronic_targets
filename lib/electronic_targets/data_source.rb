require 'electronic_targets/data_source/megalink'

module ElectronicTargets
  # Data sources are the representations of the various file formats this
  # library understands.
  module DataSource
    FILE_TYPES = {
      'mlq' => ElectronicTargets::DataSource::Megalink
    }

    def self.from_file(file, type=nil)
      raise ArgumentError, "File not found: #{file}" unless File.exists? file

      # Figure out the type of file we're dealing with
      if type.nil?
        type = FILE_TYPES.select{|e,t| file =~ /\.#{e}$/}.values.first
        raise ArgumentError, "Can't auto-detect file type" if type.nil?
      else
        raise ArgumentError, "Invalid file type" unless type.kind_of? Class
      end

      type.new(file)
    end
  end
end
