class Connector
  def initialize
    @socket = PanZMQ::Push.new
    @socket.connect("ipc:///tmp/pmodp.sock")
  end

  def set_module_attrs(mod, events, needs_message, observer_only)
    @module = mod
    @events = events
    @needs_message = needs_message
    @observer_only = observer_only
  end

  def register
    @socket.send_string MessageGenerator.registration(@module, @events, @needs_message, @observer_only)
  end

  def login
    @socket.send_string MessageGenerator.login(@module)
  end

end

#conn = Connector.new
#conn.ask("A")
#conn.ask("B")
#conn.ask("C")
