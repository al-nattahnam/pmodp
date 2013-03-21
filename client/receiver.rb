class Receiver
  def initialize
    @socket = PanZMQ::Subscribe.new
    @socket.connect "ipc:///tmp/cucub-a-in.sock"
    @socket.register

    @login_callbacks = {}
    @event_callbacks = {}
  end

  def on_login(mod, block=nil)
    @login_callbacks[mod] = block
    @socket.listen("LOGIN #{mod}")
  end

  def on_event(event, block=nil)
    @event_callbacks[event] = block
    @socket.listen("EVENT #{event}")
  end

  def set_callbacks
    @socket.on_receive do |msg|
      #puts "Receiver#set_callbacks: #{msg}"
      msg_type, msg_destination = msg.split("\n")[0].split(" ")
      #puts "Receiver#set_callbacks msg_type: #{msg_type}"
      #puts "Receiver#set_callbacks msg_destination: #{msg_destination}"

      case msg_type
        when "LOGIN"
          @login_callbacks[msg_destination].call(msg)
        when "EVENT"
          @event_callbacks[msg_destination].call(msg)
      end
    end
  end

  def close
    @socket.close
  end
end
