# encoding: utf-8
require 'rake'
require 'rake/testtask'

desc "Default: run unit tests"
task :default => :test

desc "Test Lapin"
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
