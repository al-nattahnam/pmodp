require '../lib/schema/parser'

parser = Parser.new("./context.txt")
context = parser.parse

#data_objects.each do |result|
#  puts result.inspect
#end
context.each_pair { |key, value|
  puts "#{key}: #{value}"
}
