
# require "bunny"  #the most popular ruby client

# conn = Bunny.new
# conn.start
# ch = conn.create_channel
# q = ch.queue("hello")

# # !! If uncommit this will be delieverd to 1 worker other will be send to 2 


# #ch.default_exchange.publish("Hello World Scykko", :routing_key => q.name)
# # puts "Sent 'Hello World!'"
# # conn.close


# msg = ARGV.empty? ? "Hello world" : ARGV.join(" ")

# q.publish( msg, persistent: true )
# puts " [x] Sent #{msg}"

# # By default, RabbitMQ will send each message to the next consumer, in sequence.
# # On average every consumer will get the same number of messages.
# # This way of distributing messages is called round-robin. 
# # Try this out with three or more workers.

#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch   = conn.create_channel
q    = ch.queue("task_queue", :durable => true)

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

q.publish(msg, :persistent => true)
puts " [x] Sent #{msg}"

sleep 1.0
conn.close