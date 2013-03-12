# -*- encoding: utf-8 -*-
require 'sinatra/base'
require 'multi_json'

module Lapin
  class Server < Sinatra::Base

    # Reduce the amount of data transferred 
    # from the app.
    use Rack::Deflater

    set :raise_error    => false
    set :show_exception => false

    helpers do
      # define helper methods
      def json_status(code, reason)
        content_type "application/json"
        status code
        MultiJson.encode({:status => code, :reason => reason})
      end

      def validate_json(data)
        begin
          if MultiJson.respond_to?(:adapter)
            MultiJson.load(data)
          else
            MultiJson.decode(data)
          end
          return true
        rescue
          return false
        end
      end
    end

    error do
      e = request.env['sinatra.error']
      Lapin.log "Error: #{e.class}: #{e.message}"
      json_status 412, e.message
    end

    # Create an exchange from the current AMQP connection.
    def exchange
      @exchange ||= Lapin.client.fanout(Config.exchange)
    end

    # Recieve post data, validate and redirect it
    # to an AMQP broker.
    post '/publish.json' do
      content_type :json

      begin
        # Set routing key from headers
        Config.routing_key = request.env["HTTP_X_ROUTING_KEY"]

        # Set payload from bod
        payload = request.body.read

        if validate_json(payload)
          exchange.publish(payload, :routing_key => Config.routing_key)
          # No Content
          status 204
        else
          # Bad request
          status 400
        end
      rescue Errno::ECONNRESET => e
        Lapin.log "Error: #{e.class}: #{e.message}"
        Lapin.client = nil

        # Bad gateway
        json_status 502, e.message
      rescue Bunny::ConnectionError, Bunny::ServerDownError => e
        Lapin.log "Error: #{e.class}: #{e.message}"

        # Bad gateway
        json_status 502, e.message
      end
    end
  end
end
