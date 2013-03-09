require 'pan-zmq'
require './communicator'
require './point'
require './point_manager'

class Pmodp
  
  def initialize(modules)
    @point_manager = PointManager.new(modules)
    
    @communicator = Communicator.new
    @communicator.use_point_manager(@point_manager)
  end

  def points
    @point_manager.points
  end

  def run
    @communicator.start
    while true
      PanZMQ::Poller.instance.poll
    end
  end
end
