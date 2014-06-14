module ElectronicTargets
  module Analysis
    # The score data for a particular group of shots
    class Score
      include Tools

      attr_reader :shots

      def initialize(shots)
        @shots = shots
      end

      def integer
        @integer ||= sum(shots.map(&:to_i))
      end

      def decimal
        @decimal ||= sum(shots.map{|s| s.to_f.round(1)}).round(1)
      end
    end
  end
end
