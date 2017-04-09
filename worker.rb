# #!/usr/bin/env ruby
# # encoding: utf-8

# require 'bunny'

# conn = Bunny.new

# conn.start

# ch = conn.create_channel

# q = ch.queue("hello")

# puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"

# # :durable => true  
# # This :durable option change needs to be applied to both the producer and consumer code.

# # At this point we're sure that the task_queue queue won't be lost even if RabbitMQ restarts.
# # Now we need to mark our messages as persistent - by using the :persistent option 

# # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# # x.publish(msg, :persistent => true)

# q.subscribe( manual_ack: true, block: true ) do |delivery_info, properties, body|
#   puts " [x] Received #{body}"

#   # imitate some work
#   sleep body.count(".").to_i
#   puts " [x] Done"

#   # In order to make sure a message is never lost,
#   # RabbitMQ supports message acknowledgments.
#   # An ack(nowledgement) is sent back from the consumer to tell RabbitMQ 
#   # that a particular message has been received,
#   # processed and that RabbitMQ is free to delete it.

#   ch.ack( delivery_info.delivery_tag )

# end

#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new
conn.start

ch   = conn.create_channel
q    = ch.queue("task_queue", :durable => true)

ch.prefetch(1)
puts " [*] Waiting for messages. To exit press CTRL+C"

begin
  q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
    puts " [x] Received '#{body}'"
    # imitate some work
    sleep body.count(".").to_i
    puts " [x] Done"
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  conn.close
end