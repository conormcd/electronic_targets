module ElectronicTargets
  # Data sources are the representations of the various file formats this
  # library understands.
  module DataSource
    # Common methods for all data sources
    class Base
      def shots
        raise "DataSource implementations must implement #shots"
      end

      def sighting_shots
        @sighting_shots ||= shots.select{|shot| shot.sighter?}
      end

      def match_shots
        @match_shots ||= shots.select{|shot| !shot.sighter?}
      end
    end
  end
end
