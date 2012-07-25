# encoding: utf-8
require 'bunny'

$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['RACK_ENV'] ||= 'development'

module Lapino
  VERSION = '0.1.0'

  autoload :Config, 'lapino/config'
  autoload :Server, 'lapino/server'

  class << self
    attr_accessor :options
    attr_accessor :client

    def options
      @options ||= Struct.new(:debug, :quiet).new
      @options.debug ||= false
      @options.quiet ||= false
      @options
    end

    def client
      unless @client
        c = ::Bunny.new(Config.amqp_config)
        c.start
        @client = c
      end
      @client
    end

    def debug(msg)
      if options.debug
        time = Time.now.strftime('%H:%M:%S %Y-%m-%d')
        puts "** [#{time}] $debug #$$: #{msg}"
      end
    end

    def log(msg)
      unless options.quiet
        time = Time.now.strftime('%H:%M:%S %Y-%m-%d')
        puts "** [#{time}] #$$: #{msg}"
      end
    end
  end
end
