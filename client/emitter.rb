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
end
