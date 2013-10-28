require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end

require_relative '../lib/electronic_targets'
require_relative 'spec_helper/fixtures'

RSpec.configure do |c|
  c.include SpecHelper::Fixtures
end
