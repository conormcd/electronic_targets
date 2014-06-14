module ElectronicTargets
  module Analysis
    # Some common functions for use in analyses.
    module Tools
      def mean(data)
        data.count > 0 ? sum(data) / data.count : nil
      end

      def sum(data)
        data.count > 0 ? data.inject(:+) : 0
      end
    end
  end
end
