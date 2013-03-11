require 'pan-zmq'
require_relative './connector.rb'
require_relative '../lib/message_generator.rb'

require 'forwardable'

class Client
  extend Forwardable
  
  def initialize
    @connector = Connector.new
  end

end
