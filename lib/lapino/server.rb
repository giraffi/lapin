# encoding: utf-8

require 'sinatra/base'
require 'lapino/config'
require 'multi_json'

module Lapino
  class Server < Sinatra::Base

    use Rack::Auth::Basic do |user, pass|
      user == Lapino::Config.user && pass == Lapino::Config.pass
    end

    # Reduce the amount of data transferred from the app.
    use Rack::Deflater

    set :raise_error => false
    set :show_exception => false

    helpers do
      # define helper methods
      def json_halt(code, reaseon)
        content_type "application/json"
        halt code
        MultiJson.encode({
          status: code,
          reason: reason
        })
      end

      def validate_json(data)
        begin
          decoded_data = MultiJson.decode(data)
          return true
        rescue
          return false
        end
      end
    end

    error do
      #e = request.env['sinatra.error']
      e = request.env['sinatra.error']
      puts "ERROR: #{e.class}: #{e.message}"
      json_halt 412, e.message
    end

    def client
      unless @@client
        c = Bunny.new(Lapino::Config.options)
        c.start
        @@client = c
      end
      @@client
    end

    def exchange
      @@exchange ||= client.exchange(Lapino::Config.exchange, type: 'direct')
    end

    post '/publish', provides: :json do
      content_type :json
      if validate_json(request.body)
        halt 400
      else
        exchange.publish(request.body, key: Lapino::Config.routing_key)
        status 204
      end
    end
  end
end
