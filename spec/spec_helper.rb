require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

libdir = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require_relative 'spec_helper/fixtures'
