# encoding: utf-8

require 'bunny'
require 'multi_json'
require 'sinatra'

configure :prodcution, :development do
  enable :logging
  set :raise_errors    => false
  set :show_exceptions => false
end

helpers do
  def json_status(code, reason)
    status code
    {
      :status => code,
      :reason => reason
    }.to_json
  end

  def parsed_body
    ::MultiJson.decode(request.body)
  end
end

def config
  {
    user:     'azukiarai',
    pass:     'azukiarai', 
    host:     'mq01.higanlabos.com',
    port:     '5672',
    vhost:    '/moon-rabbit-2012',
    logging:  false
  }
end

def client
  unless $client
    c = Bunny.new(config)
    c.start
    $client = c
  end
  $client
end

def exchange
  $exchange ||= client.exchange('amqp.nagios', type: 'direct')
end

post '/publish', provides: :json do
  content_type :json

  exchange.publish(payload, key: "giraffi.nagios")

  # Bad Request
  # A request body format is not correct.
  #400

  # Unauthorized
  # A request can not be allowed with the given token.
  #401

  # Bad gateway
  # The server received an invalid response from an upstream server.
  #502

  # No Content: response without entity body
  204
end

## error handlers: error, not_found, etc.

get "*" do
  status 404
end

put_or_post "*" do
  status 404
end

delete "*" do
  status 404
end

not_found do
  json_status 404, "Not found"
end

error do
  json_status 500, env['sinatra.error'].message
end
