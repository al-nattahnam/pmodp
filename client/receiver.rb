class Receiver
  def initialize
    @receiver = PanZMQ::Subscribe.new
    @receiver.connect "ipc:///tmp/cucub-a-in.sock"
    @receiver.register
  end

  def bind(event, block)
    @receiver.listen("")
    @receiver.on_receive do |msg|
      # according to message event...
      block.call(msg)
    end
  end
end
