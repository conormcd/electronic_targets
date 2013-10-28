require 'ole/storage'

module ElectronicTargets
  module DataSource
    # Read data from SCATT data files.
    class SCATT
      attr_accessor :path

      def initialize(path)
        @path = path

        raise ArgumentError, "No path to SCATT file provided" if @path.nil?
        raise ArgumentError, "#{@path} not found" unless File.exists? @path
      end

      def data
        @data ||= Ole::Storage.open(@path, 'rb+').file.read('Contents')
      end

      def shots
        # TODO: Convert data into shots
        @shots ||= []
      end

      def target
        raise ArgumentError, "Unknown target type."
      end
    end
  end
end
