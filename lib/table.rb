require_relative 'validations'

# the playing surface of the simulation
class Table

  include Validations
  
  attr_reader :width, :height

  def initialize(width, height)
    @width =  width.respond_to?(:to_i)  && width.to_i > 0 ? width.to_i : 0
    @height = height.respond_to?(:to_i) && height.to_i > 0 ? height.to_i : 0
  end

  def valid_position?(x_position, y_position)
    return false unless integer?(x_position) && integer?(y_position)
    return false unless @width > 0 && @height > 0
    
    x_position.to_i.between?(0,@width) && y_position.to_i.between?(0,@height)
  end

end