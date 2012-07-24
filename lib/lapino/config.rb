# encoding: utf-8
require 'uri'

module Lapino
  class Config

    class << self
      attr_accessor :amqp_url
      attr_accessor :exchange, :routing_key
      attr_accessor :logging

      def amqp_config
        uri = URI.parse(amqp_url)
        {
          user: uri.user,
          pass: uri.password,
          host: uri.host,
          port: (uri.port || 5672),
          vhost: uri.path,
          logging: @logging || false
        }
      rescue Object => e
        raise "Invalid AMQP url: #{uri.inspect} (#{e})"
      end

      def amqp_url
        @amqp_url ||= ENV["AMQP_URL"] || "amqp://guest:guest@localhost"
      end

      def exchange
        @exchange ||= "amq.direct"
      end

      def routing_key
        @routing_key ||= "*"
      end
    end
  end
end
