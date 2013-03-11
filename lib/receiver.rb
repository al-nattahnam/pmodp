class Receiver
  def initialize
    @socket = PanZMQ::Pull.new
    @socket.bind("ipc:///tmp/pmodp.sock")
  end

  def start
    $stdout.puts "Started Receiving"
    @socket.on_receive do |msg|
      action, body = msg.split(" ")
      $stdout.puts msg
      #case action
      #  when "REGISTER"
      #    
      #end
    end
    @socket.register
  end
end
