require_relative './client.rb'

class ModuleClient < Client
  def_delegators :@connector, :register, :login

  def initialize(mod, events, needs_message, observer_only)
    super()
    @module = mod
    @events = events
    @needs_message = needs_message
    @observer_only = observer_only

    @connector.set_module_attrs(@module, @events, @needs_message, @observer_only)
  end
end
