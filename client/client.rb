# require 'ffi-rzmq'

require 'pan-zmq'

require_relative './message_generator.rb'
require_relative './emitter.rb'
require_relative './receiver.rb'

require_relative '../dci/parser.rb'

# TODO rename to Client
class Client
  def initialize
    @emitter = Emitter.new
    @receiver = Receiver.new(:client => self)
  end

  def set_module_attrs(mod, events, needs_message, observer_only)
    @module = mod
    @events = events
    @needs_message = needs_message
    @observer_only = observer_only
  end

  #def register
  #  @emitter.registration(@module, @events, @needs_message, @observer_only)
  #end

  #def login
  #  @emitter.login(@module)
  #end

  def trigger_event(event, additionals={})
    @emitter.event(@module, event, additionals)
  end

  def trigger_process(mod, process_name, additionals={})
    @emitter.process(mod, process_name, additionals)
  end

  def bind_context_definition
    @receiver.on_context_definition(@module)
  end

  def bind_login(mod, &block)
    @receiver.on_login(mod, block)
  end

  def bind(event, &block)
    @receiver.on_event(event, block)
  end

  def bind_process(process_name, &block)
    @receiver.on_process(@module, process_name, block)
  end

  def catch_result(mod, process_name, &block)
    @receiver.on_event("#{mod}:#{process_name}.finished", block)
  end

  def send_context(mod, definition_path)
    definition = Parser.new(definition_path).parse
    
    @emitter.context_definition(mod, definition)
  end

  def consume
  #  # Use fibers so we dont poll under activity
    #Thread.new do
      @receiver.set_callbacks
      @emitter.login(@module)
      while true
        PanZMQ::Poller.instance.poll
      end
    #end
  end

  def close
    @receiver.close
    @emitter.close
  end

end
