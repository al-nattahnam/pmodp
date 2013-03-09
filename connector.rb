class Connector
  def initialize
    @socket = PanZMQ::Request.new
    @socket.connect("ipc:///tmp/pmodp.sock")
  end
  
  # This will use the self.module_name only
  def ask(mod)
    @socket.send_string mod
    eval(@socket.recv_string)
  end

  def first
    @socket.send_string 'first'
    @socket.recv_string
    # eval(@socket.recv_string)
  end
end

#conn = Connector.new
#conn.ask("A")
#conn.ask("B")
#conn.ask("C")
