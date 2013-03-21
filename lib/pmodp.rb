require 'pan-zmq'
require_relative './receiver'
#require_relative './event_bus'
require_relative './point'
require_relative './point_manager'

class Pmodp

  INTERNAL_MODULE_NAME = "pmodp"
  
  def initialize(modules)
    @point_manager = PointManager.new(modules)
    
    @receiver = Receiver.new
    
    #@event_bus = EventBus.new
    #@event_bus.use_point_manager(@point_manager)
  end

  def points
    @point_manager.points
  end

  def run
    @receiver.start
  #  #@communicator.start
    while true
      PanZMQ::Poller.instance.poll
    end
  end
end
