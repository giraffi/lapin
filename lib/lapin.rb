# -*- encoding: utf-8 -*-

$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['RACK_ENV'] ||= 'development'

require 'bunny'
require 'lapin/config'
require 'lapin/server'

module Lapin
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
        conn = Bunny.new(Config.amqp_config)
        conn.start
        conn.create_channel
        @client = conn
      end
      @client
    end

    def log(msg)
      unless options.quiet
        time = Time.now.strftime('%H:%M:%S %Y-%m-%d')
        puts "** [#{time}] #$$: #{msg}"
      end
    end
  end
end
