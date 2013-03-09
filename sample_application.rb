require '/home/krakatoa/workspace/al-nattahnam/pan-zmq/lib/pan-zmq.rb'
# require 'pan-zmq'
require './connector'

class Application
  def initialize(mod)
    @module = mod
  end

  def setup
    get_info
    set_pipelining
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
    start_pipelining
  end

  private
  def get_info
    conn = Connector.new
    @info = conn.ask(@module)
  end

  def set_pipelining
    $stdout.puts "setting pipelining with this info: #{@info}"
    # It should retry until connections are done on all point_bs

    @in = PanZMQ::Reply.new
    @in.bind(@info[:path])
    @in.register

    if @info[:output_path]
      @out = PanZMQ::Request.new
      @out.connect(@info[:output_path])
    end
    
    @in.on_receive do |msg|
      @in.send_string('received')
      output = process msg
      if @info[:output_path]
        @out.send_string(output)
        @out.recv_string
      else
        $stdout.puts "ended: #{msg} at #{Time.now}"
      end
    end
  end

  def start_pipelining
    # Use fibers so we dont poll under activity
    #Thread.new do
      while true
        PanZMQ::Poller.instance.poll
      end
    #end
  end
end
