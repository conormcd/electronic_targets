module ElectronicTargets
  module Analysis
    # Information about the position of a group of shots.
    class Position
      include Tools

      attr_reader :shots

      def initialize(shots)
        @shots = shots
      end

      def centred_shots
        @centred_shots ||= shots.map(&:dup).map do |shot|
          shot.horizontal_error -= x
          shot.vertical_error -= y
          shot
        end
      end

      def x
        @x ||= mean(shots.map(&:horizontal_error))
      end

      def y
        @y ||= mean(shots.map(&:vertical_error))
      end
    end
  end
end
