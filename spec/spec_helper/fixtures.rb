require 'spec_helper/fixtures/data_source/megalink'

module SpecHelper
  module Fixtures
    def megalink_fixtures
      @@megalink_fixtures ||= SpecHelper::Fixtures::DataSource::Megalink.new
    end
  end
end
