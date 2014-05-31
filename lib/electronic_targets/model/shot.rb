module ElectronicTargets
  module Model
    # Model a single shot
    class Shot
      attr_accessor :card
      attr_accessor :horizontal_error
      attr_accessor :target
      attr_accessor :vertical_error
      attr_writer :time

      def initialize
        # Default
        @card = nil
        @horizontal_error = nil
        @target = nil
        @time = nil
        @vertical_error = nil

        yield self if block_given?

        # Validate
        if @horizontal_error.nil?
          raise ArgumentError, "No horizontal error provided"
        end
        if @vertical_error.nil?
          raise ArgumentError, "No vertical error provided"
        end
        if @time.nil?
          raise ArgumentError, "No shot time provided"
        end
        if @time < 0
          raise ArgumentError, "Negative time provided"
        end
        if @target.nil?
          raise ArgumentError, "No target provided"
        end
      end

      def score
        target.score(self)
      end

      def error
        Math.sqrt((horizontal_error ** 2) + (vertical_error ** 2))
      end

      def to_i
        score.to_i
      end

      def to_f
        score.to_f
      end

      def time(format=nil)
        if format
          Time.at(@time).gmtime.strftime(format)
        else
          @time
        end
      end
    end
  end
end
