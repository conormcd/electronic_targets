require 'singleton'

module ElectronicTargets
  module Model
    module Target
      # A base target type for all targets to inherit from
      class Base
        include Singleton

        def score(x, y)
          raise NotImplementedError, "You may not use #{self.class} directly."
        end

        def radius(x, y)
          Math.sqrt((x * x) + (y * y))
        end
      end

      # A base target type for all ring type targets to inherit from
      class RingTarget < Base
        attr_reader :decimal_places
        attr_reader :inward_gauging
        attr_reader :max_score
        attr_reader :ring_size
        alias inward_gauging? inward_gauging

        def initialize
          super
          @decimal_places = 0
          @inward_gauging = true
          @max_score = 10.9
          @ring_size = 0
        end

        def score(x, y)
          score_increment = 1.0 / (10 ** decimal_places)

          deduction = (radius(x, y) / (ring_size * score_increment))
          deduction = inward_gauging? ? deduction.ceil : deduction.floor
          deduction *= score_increment

          score = (max_score + score_increment) - deduction
          score = 0 if score < 0
          score = max_score if score > max_score
          score.round(decimal_places)
        end
      end
    end
  end
end

require 'electronic_targets/model/target/issf_10m_rifle'
require 'electronic_targets/model/target/issf_50m_rifle'
