# -*- encoding: utf-8 -*-
require 'uri'

module Lapin
  class Config

    class << self
      attr_accessor :amqp_url, :vhost
      attr_accessor :exchange, :routing_key, :queue
      attr_accessor :logging

      def amqp_config
        uri = URI.parse(amqp_url)
        {
          :user    => uri.user,
          :pass    => uri.password,
          :host    => uri.host,
          :port    => uri.port || 5672,
          :vhost   => @vhost || uri.path,
          :logging => @logging || false
        }
      rescue Object => e
        raise "Invalid AMQP url: #{uri.inspect} (#{e})"
      end

      def amqp_url
        @amqp_url ||= ENV["AMQP_URL"] || "amqp://guest:guest@localhost"
      end

      def vhost
        @vhost
      end

      def exchange
        @exchange ||= "amq.fanout"
      end

      def routing_key
        @routing_key ||= "*"
      end
    end
  end
end
