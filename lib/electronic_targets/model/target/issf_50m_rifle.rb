module ElectronicTargets
  module Model
    module Target
      # An ISSF 50 meter rifle target
      class ISSF50mRifle < RingTarget
        def initialize
          super
          @calibre = 5.6
          @max_score = 10.9
          @ring_size = 8
          @decimal_places = 1
          @inward_gauging = true
        end
      end
    end
  end
end
