require_relative 'validations'

# the playing surface of the simulation
class Table

  include Validations
  
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  # 
  def valid_position?(x_position, y_position)
    return false unless integer?(@width) && integer?(@height)
    return false unless integer?(x_position) && integer?(y_position)
    
    x_position.to_i.between?(0,@width) && y_position.to_i.between?(0,@height)
  end

end