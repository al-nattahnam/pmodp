require_relative './client/client.rb'

class BusinessLogic

  def self.process(mod, msg)
    $stdout.puts "@#{mod}: processing"
    sleep 1

    new_message = msg.dup
    new_message["sum"] = msg["a"].to_i + msg["b"].to_i

    return new_message
  end

end

class Interface
  def initialize(mod, events, needs_message, observer_only)
    @module = mod
    @client = Client.new # (mod, events, needs_message, observer_only)
    @client.set_module_attrs(mod, events, needs_message, observer_only)
  end

  def run
    bind_context_definition
    #login
    @client.bind_process("process") do |msg|
      $stdout.puts "@#{@module} llego #{msg}"
      BusinessLogic.process(@module, msg)
    end

    @client.consume
  end

  def shutdown
    @client.close
  end
  private
  #def login
  #  @client.login
  #end
  def bind_context_definition
    @client.bind_context_definition
  end

end

app = Interface.new("Mod-B", ["received"], true, false)
trap("INT") { app.shutdown; PanZMQ.terminate }
#app.register_event("Mod-A:done")
app.run
