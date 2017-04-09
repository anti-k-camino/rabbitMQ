#!/usr/bin/env ruby
# encoding: utf-8

require 'bunny'

# Setting up is the same as the producer; we open a connection and a channel,
# and declare the queue from which we're going to consume.
# Note this matches up with the queue that send publishes to.
conn = Bunny.new

conn.start

ch = conn.create_channel

#we declare the queue here, as well. 
# Because we might start the consumer before the producer, 
#we want to make sure the queue exists before we try to consume messages from it.

q = ch.queue("hello")

# We're about to tell the server to deliver us the messages from the queue.
# Since it will push us messages asynchronously,
# we provide a callback that will be executed when RabbitMQ pushes messages to our consumer.
# This is what Bunny::Queue#subscribe does.

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"

q.subscribe( :block => true ) do |delivery_info, properties, body|
  puts " [x] Received #{body}"
  # cancel the consumer to exit
  delivery_info.consumer.cancel
end

# Bunny::Queue#subscribe is used with the :block option that makes 
# it block the calling thread (we don't want the script to finish running immediately!).

# !!!!!!!!
# You may wish to see what queues RabbitMQ has and how many messages are in them.
# You can do it (as a privileged user) using the rabbitmqctl tool:

# sudo rabbitmqctl list_queues