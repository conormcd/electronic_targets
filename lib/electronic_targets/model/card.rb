module ElectronicTargets
  module Model
    # Model a "card" or specified string of shots.
    class Card
      attr_accessor :name

      def initialize
        @name = nil

        yield self if block_given?
      end
    end
  end
end
