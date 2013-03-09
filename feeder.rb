require 'pan-zmq'
require './connector'

conn = Connector.new
first_path = conn.first

$stdout.puts "Will feed to path: #{first_path}"
feeder = PanZMQ::Request.new
feeder.connect first_path

$stdout.puts "started: #{Time.now}"
10.times do |i|
  feeder.send_string "task n##{i}"
  feeder.recv_string
end
$stdout.puts "finished sending: #{Time.now}"
