require 'csv'

module SpecHelper
  module Fixtures
    module DataSource
      class SCATT
        def scatt_files
          Dir.glob(
            File.join(
              File.expand_path(
                "../../../../fixtures/data_source/scatt",
                __FILE__
              ),
              '*.scatt'
            )
          )
        end

        def scatt
          @scatt ||= Hash[scatt_files.map{|path| [File.basename(path), path]}]
        end
      end
    end
  end
end
