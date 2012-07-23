# encoding: utf-8

module Lapino
  class Config
    class << self
      attr_accessor :user, :pass, :host, :port, :vhost
      attr_accessor :exchange, :routing_key
      attr_accessor :logging

      def options
        {
          user: @user,
          pass: @pass,
          host: @host,
          port: @port,
          vhost: @vhost,
          logging: @logging
        }
      end
    end
  end
end
