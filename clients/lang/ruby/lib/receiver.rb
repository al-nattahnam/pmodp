class Receiver
  def initialize(opts={})
    @socket = PanZMQ::Subscribe.new
    @socket.connect "ipc:///tmp/cucub-a-in.sock"
    @socket.register

    @client = opts[:client]

    @login_callbacks = {}
    @event_callbacks = {}
    @process_callbacks = {}
  end

  def on_login(mod, block=nil)
    @login_callbacks[mod] = block
    @socket.listen("LOGIN #{mod}")
  end

  def on_event(event, block=nil)
    @event_callbacks[event] = block
    @socket.listen("EVENT #{event}")
  end

  def on_process(mod, proc_name, block=nil)
    callback_name = "#{mod}##{proc_name}"
    
    @process_callbacks[callback_name] = Proc.new { |msg|
      @client.trigger_event("#{proc_name}.started")
      @client.trigger_event("#{proc_name}.finished", {:result => block.call(msg)})
    }
    @socket.listen("PROCESS #{mod}##{proc_name}")
  end

  def on_context_definition(mod)
    @socket.listen("CONTEXT_DEFINITION #{mod}")
  end

  def set_callbacks
    @socket.on_receive do |msg|
      #puts "Receiver#set_callbacks: #{msg}"
      header = msg.split("\n")[0]
      body = msg.split("\n")[1..-1]

      msg_type, msg_destination = header.split(" ")
      #puts "Receiver#set_callbacks msg_type: #{msg_type}"
      #puts "Receiver#set_callbacks msg_destination: #{msg_destination}"

      case msg_type
        when "LOGIN"
          @login_callbacks[msg_destination].call(msg)
        when "CONTEXT_DEFINITION"
          read_context_definition(msg)
        when "PROCESS"
          @process_callbacks[msg_destination].call(parse_body(body))
        when "EVENT"
          @event_callbacks[msg_destination].call(parse_body(body))
      end
    end
  end

  def read_context_definition(definition)
    $stdout.puts "should set: #{definition}"
  end

  def close
    @socket.close
  end

  private
  def parse_body(body)
    body.inject({}) {|h, l| n,v = l.split(": "); h[n] = v; h}
  end
end
