class PointManager
  attr_reader :points
  
  def initialize(modules=[])
    @modules = modules
    assign_points
  end

  def assign_points
    # This should handle point types (languages), so instead of using an Unix Socket, it may use an inproc.
    order = 1
    @points = @modules.inject [] do |h, mod|
      h << Point.new(gen_id, mod, order, base_path)
      
      order += 1
      
      h
    end
  end

  def info_for_module(mod)
    point_a = @points.select { |point| point.module == mod }[0]
    point_b = @points.select { |point| point.order == point_a.order + 1 }[0]

    info = {}
    info[:path] = point_a.path
    info[:output_path] = point_b.path rescue nil
    info
  end

  def first_path
    @points.select { |point| point.order == 1 }[0].path
  end

  #def path_for_module(mod)
  #  @points.select { |point| point.module == mod }[0].path
  #end
  
  private
  def gen_id
    rand(500)
  end

  def base_path
    "/tmp"
  end

end
