module ShootingStats
  module Model
    module Target
      # An ISSF 10 meter rifle target
      class ISSF10mRifle < RingTarget
        def initialize
          super
          @decimal_places = 1
          @inward_gauging = true
          @max_score = 10.9
          @ring_size = 2.5
        end
      end
    end
  end
end
