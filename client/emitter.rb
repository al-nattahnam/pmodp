class Emitter
  def initialize
    @socket = PanZMQ::Push.new
    @socket.connect("ipc:///tmp/cucub-a.sock")
  end

  def registration(mod, events, needs_message, observer_only)
    @socket.send_string MessageGenerator.registration(mod, events, needs_message, observer_only)
  end

  def login(mod)
    @socket.send_string MessageGenerator.login(mod)
  end

  def event(mod, event, additionals)
    @socket.send_string MessageGenerator.event(mod, event, additionals)
  end

  def close
    @socket.close
  end
end
