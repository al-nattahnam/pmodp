class EventBus
  def initialize
    @socket = PanZMQ::Broadcast.new
    @socket.bind("ipc:///tmp/pmodp-event-bus.sock")
  end

  def use_point_manager(point_manager)
    @point_manager = point_manager
  end

  def info_for_module(mod)
    @point_manager.info_for_module(mod).to_s
  end

  #def path_for_module(mod)
  #  @point_manager.path_for_module(mod)
  #end

  def start
    $stdout.puts "Started Event Bus"
    @socket.on_receive do |msg|
      case msg
        when "first"
          resp = @point_manager.first_path
          @socket.send_string resp
        else
          resp = info_for_module(msg)
          @socket.send_string resp
      end
    end
    @socket.register
  end

end
