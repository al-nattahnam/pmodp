require 'pan-zmq'
require_relative '../client/client.rb'

class Manager

  INTERNAL_MODULE_NAME = "manager"
  
  def initialize(modules=[])
    #@point_manager = PointManager.new(modules)

    @modules = modules

    @client = Client.new
    
    #@event_bus = EventBus.new
    #@event_bus.use_point_manager(@point_manager)
  end

  #def points
  #  @point_manager.points
  #end

  def run
    @modules.each do |mod|
      @client.bind_login(mod) do |msg|
        puts "Se logueo: #{msg}"
      end
    end
    @client.consume
  end

  def shutdown
    @client.close
  end
end

manager = Manager.new(["Mod-A", "Mod-B"])
manager.run
