module ElectronicTargets
  # Data sources are the representations of the various file formats this
  # library understands.
  module DataSource
    # Most data sources are backed by a file, common methods for those go here.
    class FileBacked < Base
      attr_accessor :file

      def initialize(file)
        @file = file

        raise ArgumentError, "No file provided" if @file.nil?
        raise ArgumentError, "#{@file} not found" unless File.exist? @file
      end
    end
  end
end
