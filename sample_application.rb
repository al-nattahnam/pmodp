require_relative './client/module_client.rb'

class Application
  def initialize(mod, events, needs_message, observer_only)
    @module = mod
    @client = ModuleClient.new(mod, events, needs_message, observer_only)
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
  end

  private
  def register
    @client.register
  end

  def login
    @client.login
  end

  #def start_pipelining
  #  # Use fibers so we dont poll under activity
  #  #Thread.new do
  #    while true
  #      PanZMQ::Poller.instance.poll
  #    end
  #  #end
  #end
end
