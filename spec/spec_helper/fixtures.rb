require 'spec_helper/fixtures/data_source/megalink'
require 'spec_helper/fixtures/data_source/scatt'

module SpecHelper
  module Fixtures
    def megalink_fixtures
      @@megalink_fixtures ||= SpecHelper::Fixtures::DataSource::Megalink.new
    end

    def scatt_fixtures
      @@scatt_fixtures ||= SpecHelper::Fixtures::DataSource::SCATT.new
    end
  end
end
