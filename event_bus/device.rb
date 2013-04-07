require 'ffi-rzmq'

ctx = ZMQ::Context.new

frontend = ctx.socket ZMQ::PULL
backend = ctx.socket ZMQ::PUB

frontend.bind("ipc:///tmp/cucub-a.sock")
# frontend.setsockopt(ZMQ::SUBSCRIBE, "")

backend.bind("ipc:///tmp/cucub-a-in.sock")

device = ZMQ::Device.new(ZMQ::FORWARDER, frontend, backend)
