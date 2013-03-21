require './client/message_generator'

# puts MessageGenerator.registration("console", ["received", "finished"], true, false)

puts "\n"

puts MessageGenerator.login("console")

puts "\n"

puts MessageGenerator.process("uuid-1234", "--serialized-message--")
#puts MessageGenerator.event("pmodp", "uuid-1234", "new_message", {"Time" => Time.now})

puts "\n"

puts MessageGenerator.delegation("console", "uuid-1234", "--serialized-message--")
#puts MessageGenerator.event("pmodp", "uuid-1234", "delegated", {"Time" => Time.now})

puts "\n"

#puts MessageGenerator.event("console", "uuid-1234", "serialized", {"Serialized" => "{blabla => bloblo}"})

puts MessageGenerator.return("console", "uuid-1234")

puts "\n"

#puts MessageGenerator.event("pmodp", "uuid-1234", "finished", {"Time" => Time.now})
