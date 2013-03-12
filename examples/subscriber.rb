#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require "amqp"
require "multi_json"

AMQP.start("amqp://localhost:5672/") do |conn|
  channel  = AMQP::Channel.new(conn)
  exchange = channel.fanout('logs')
  queue    = channel.queue("", :auto_delete => true).bind(exchange, :routing_key => 'amq.giraffi')

  Signal.trap("INT") do
    conn.close do
      EM.stop { exit }
    end
  end

  puts " [*] Waiting for logs. To exit press CTRL+C"

  queue.subscribe do |metadata, payload|
    puts " [x] #{MultiJson.load(payload)}"
  end
end
