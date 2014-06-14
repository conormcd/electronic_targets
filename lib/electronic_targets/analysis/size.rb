module ElectronicTargets
  module Analysis
    # Information about the size of a group of shots.
    class Size
      attr_reader :calibre
      attr_reader :shots

      def initialize(shots, calibre)
        @shots = shots
        @calibre = calibre
      end

      def diameter
        @diameter ||= shots.combination(2).map do |s|
          Math.sqrt(
            ((s[0].horizontal_error - s[1].horizontal_error) ** 2) +
            ((s[0].vertical_error - s[1].vertical_error) ** 2)
          )
        end.max + calibre
      end

      def height
        @height ||= extent(shots.map(&:vertical_error)) + calibre
      end

      def width
        @width ||= extent(shots.map(&:horizontal_error)) + calibre
      end

      private

      def extent(data)
        min = nil
        max = nil
        data.each do |datum|
          min = [min, datum].compact.min
          max = [max, datum].compact.max
        end
        min.abs + max.abs
      end
    end
  end
end
