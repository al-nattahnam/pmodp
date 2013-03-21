require_relative './client/client.rb'

class Application
  def initialize(mod, events, needs_message, observer_only)
    @module = mod
    @client = Client.new # (mod, events, needs_message, observer_only)
    @client.set_module_attrs(mod, events, needs_message, observer_only)
  end

  def setup
    register
  end

  def process(msg)
    $stdout.puts "processing"
    $stdout.puts msg
    sleep 1
    $stdout.puts "finished\n"

    new_msg = msg

    return new_msg
  end

  def run
    login
    @client.bind("event") do |msg|
      puts "Llego: #{msg}"
    end
    @client.consume
  end

  private
  def register
    @client.register
  end

  def login
    @client.login
  end

end

@n = rand(50)
app = Application.new("Mod-#{@n}", ["received"], true, false)
app.setup
app.run
