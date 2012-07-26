#!/usr/bin/ruby
# encoding: utf-8

require "amqp"

AMQP.start(host: 'localhost') do |conn|
  channel  = AMQP::Channel.new(conn)
  exchange = channel.direct('amqp.nagios')
  queue    = channel.queue("", exclusive: true)
  queue.bind(exchange, routing_key: 'giraffi.nagios')

  Signal.trap("INT") do
    conn.close do
      EM.stop { exit }
    end
  end

  puts " [*] Waiting for logs. To exit press CTRL+C"

  i = 1
  queue.subscribe do |header, payload|
    #puts " [x] #{header}:#{payload}"
    puts " [x] #{header} ----- #{i}"
    i += 1
  end
end
