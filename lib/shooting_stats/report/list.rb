module ShootingStats
  module Report
    # A simple report which just lists the shots read from the source
    class List
      def generate_from(source)
        source.shots.each do |shot|
          printf(
            "%s % 4s\n",
            shot.time('%H:%M:%S'),
            shot.score
          )
        end
      end
    end
  end
end
