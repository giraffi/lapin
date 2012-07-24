# encoding: utf-8

require 'sinatra/base'
require 'multi_json'

module Lapino
  class Server < Sinatra::Base

    # Reduce the amount of data transferred 
    # from the app.
    use Rack::Deflater

    set :raise_error    => false
    set :show_exception => false

    helpers do
      # define helper methods
      def json_halt(code, reaseon)
        content_type "application/json"
        halt code
        ::MultiJson.encode({
          status: code,
          reason: reason
        })
      end

      def validate_json(data)
        begin
          ::MultiJson.decode(data)
          return true
        rescue
          return false
        end
      end
    end

    error do
      e = request.env['sinatra.error']
      Lapino.log "ERROR: #{e.class}: #{e.message}"
      json_halt 412, e.message
    end

    # Create an exchange from the current AMQP connection.
    def exchange
      @exchange ||= Lapino.client.exchange(Config.exchange, type: 'direct')
    end

    # Recieve post data, validate and redirect it
    # to an AMQP broker.
    post '/publish', provides: :json do
      content_type :json
      if validate_json(request.body)
        exchange.publish(request.body, key: Config.routing_key)
        # No Content
        status 204
      else
        # Bad request
        halt 400
      end
    end
  end
end
