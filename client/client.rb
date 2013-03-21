# require 'ffi-rzmq'

require 'pan-zmq'

require_relative './message_generator.rb'
require_relative './emitter.rb'
require_relative './receiver.rb'

# TODO rename to Client
class Client
  def initialize
    @emitter = Emitter.new
    @receiver = Receiver.new
  end

  def set_module_attrs(mod, events, needs_message, observer_only)
    @module = mod
    @events = events
    @needs_message = needs_message
    @observer_only = observer_only
  end

  def register
    @emitter.registration(@module, @events, @needs_message, @observer_only)
  end

  def login
    @emitter.login(@module)
  end

  def bind(event, &block)
    #@receiver.listen
    #@receiver.on_receive do |msg|
    #  block.call(msg)
    #end
    @receiver.bind(event, block)
  end

  def consume
  #  # Use fibers so we dont poll under activity
    #Thread.new do
      while true
        PanZMQ::Poller.instance.poll
      end
    #end
  end

end
