module ElectronicTargets
  module Analysis
    # A central interface for gathering data about a set of shots.
    class Report
      extend Forwardable

      def_delegator :@centred_score, :decimal, :centred_decimal_score
      def_delegator :@centred_score, :integer, :centred_integer_score
      def_delegator :@position, :x, :mean_horizontal_error
      def_delegator :@position, :y, :mean_vertical_error
      def_delegator :@score, :decimal, :decimal_score
      def_delegator :@score, :integer, :integer_score
      def_delegator :@size, :diameter, :group_diameter
      def_delegator :@size, :height, :group_height
      def_delegator :@size, :width, :group_width

      def initialize(data_source)
        @position = Position.new(data_source.match_shots)
        @score = Score.new(data_source.match_shots)
        @centred_score = Score.new(@position.centred_shots)
        @size = Size.new(data_source.match_shots, data_source.target.calibre)
      end
    end
  end
end
