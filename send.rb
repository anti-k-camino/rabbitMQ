#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"  #the most popular ruby client

conn = Bunny.new
# conn = Bunny.new(:hostname => "rabbit.local") #for a remote host
conn.start
# we create a channel, which is where most of the API for getting things done resides:
ch = conn.create_channel
# To send, we must declare a queue for us to send to; then we can publish a message to the queue:
q = ch.queue("hello")
ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts "Sent 'Hello World!'"
# Declaring a queue is idempotent - it will only be created if it doesn't exist already. The message content is a byte array, so you can encode whatever you like there.
conn.close