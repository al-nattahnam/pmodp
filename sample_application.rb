require_relative './client/client.rb'

class BusinessLogic
  #def shout
  #  @client.trigger_event("done", {"Id" => 1, "Task" => "build"})
  #end

  #def respond(event)
  #  @client.trigger_event("ok")
  #end

  def self.shout(interface, mod)
    interface.trigger_process(mod, "process", {:a => rand(5), :b => rand(5)})
  end

  #def register_event(event)
  #  @client.bind(event) do |msg|
  #    puts "@#{@module} llego #{event}: #{msg}"
  #    @client.trigger_event("ok")
  #  end
  #end
end

class Interface
  def initialize(mod, events, needs_message, observer_only)
    @module = mod
    @client = Client.new # (mod, events, needs_message, observer_only)
    @client.set_module_attrs(mod, events, needs_message, observer_only)
  end

  def run
    #login

    @client.catch_result("Mod-B", "process") do |msg|
      $stdout.puts "@#{@module} termino #{msg}"
    end

    @client.consume
  end

  def trigger_process(mod, process, additionals={})
    @client.trigger_process(mod, "process", additionals)
  end

  def shutdown
    @client.close
  end
  private
  #def login
  #  @client.login
  #end

end

app = Interface.new("Mod-A", ["received"], true, false)
#app.register_event("Mod-B:ok")
thread = Thread.new do
  while true
    sleep 1
    BusinessLogic.shout(app, "Mod-B")
  end
end
trap("INT") { thread.kill; app.shutdown; PanZMQ.terminate }
app.run
