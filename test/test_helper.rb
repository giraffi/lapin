# -*- encoding: utf-8 -*-

require 'rubygems'
require 'bundler'

# Configure Rack Environment
ENV['RACK_ENV'] = "test"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundleError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'lapin'

class Test::Unit::TestCase
end
