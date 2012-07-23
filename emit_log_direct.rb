#!/usr/bin/env ruby
# encoding: utf-8

require "amqp"

AMQP.start(
  host: 'mq01.higanlabos.com',
  vhost: '/moon-rabbit-2012',
  user: 'azukiarai',
  pass: 'azukiarai'
  #host: 'localhost'
) do |connection|

  channel  = AMQP::Channel.new(connection)
  exchange = channel.direct("amqp.nagios")
  message  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

  exchange.publish(message, :routing_key => 'giraffi.nagios')
  #exchange.publish(message)
  puts " [x] Sent #{message}"

  EM.add_timer(2.5) do
    connection.close do
      EM.stop { exit }
    end
  end
end
