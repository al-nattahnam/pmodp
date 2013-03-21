require_relative './client/client.rb'

class Application
  def initialize(mod, events, needs_message, observer_only)
    @module = mod
    @client = Client.new # (mod, events, needs_message, observer_only)
    @client.set_module_attrs(mod, events, needs_message, observer_only)
  end

  def setup
    #register
  end

  def shout
    @client.trigger_event("done", {"Id" => 1, "Task" => "build"})
  end

  def respond(event)
    @client.trigger_event("ok")
  end

  def process(msg)
    $stdout.puts "processing"
    $stdout.puts msg
    sleep 1
    $stdout.puts "finished\n"

    new_msg = msg

    return new_msg
  end

  def register_event(event)
    @client.bind(event) do |msg|
      puts "Llego: #{msg}"
      @client.trigger_event("ok")
    end
  end

  def run
    login
    @client.consume
  end

  def shutdown
    @client.close
  end
  private
  def register
    @client.register
  end

  def login
    @client.login
  end


end

fork do
  app = Application.new("Mod-A", ["received"], true, false)
  trap("INT") { app.shutdown; PanZMQ.terminate }
  app.setup
  app.register_event("Mod-B:ok")
  Thread.new do
    while true
      sleep 1
      app.shout
    end
  end
  app.run
end

fork do
  app = Application.new("Mod-B", ["received"], true, false)
trap("INT") { app.shutdown; PanZMQ.terminate }
  app.setup
  app.register_event("Mod-A:done")
  app.run
end

Process.waitall
