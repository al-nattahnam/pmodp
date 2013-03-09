class Point
  attr_reader :module, :path, :order
  
  def initialize(id, mod, order, base_path)
    @module = mod
    @id = id
    @path = "ipc://#{base_path}/#{id.to_s}.sock"
    @order = order
  end
end
