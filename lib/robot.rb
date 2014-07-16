# the class representing a toy robot

class Robot

  attr_reader :surface, :x_position, :y_position, :heading, :all_headings

  def initialize
    @surface = nil
    @x_position = nil
    @y_position = nil   
    @all_headings = [:north, :east, :south, :west]
  end

  def place(surface, x_position, y_position, heading)
    return false unless valid_placement?(surface, x_position, y_position) && valid_heading?(heading)
    
    @surface = surface
    @x_position = x_position.to_i
    @y_position = y_position.to_i
    @heading = heading
    placed?
  end

  def move_forward
    return false unless placed?

    case @heading.downcase.to_sym
    when :north
      place(@surface, @x_position, @y_position+1, @heading)
    when :east
      place(@surface, @x_position+1, @y_position, @heading)
    when :south
      place(@surface, @x_position, @y_position-1, @heading)
    when :west
      place(@surface, @x_position-1, @y_position, @heading)
    else
      raise "Invalid heading supplied: " + (@heading || "not placed")
    end
  end

  def placed?
    !!@surface && !!@x_position && !!@y_position && !!@heading
  end

  def rotate_left
    rotate(-1)
  end

  def rotate_right
    rotate(1)
  end

  def report_location
    placed? ? "#{@x_position},#{@y_position},#{@heading.upcase}" : nil
  end
  
  private

    def rotate(rotation)
      if placed?
        index = @all_headings.index(@heading.downcase.to_sym)
        @heading = @all_headings.rotate(rotation+index)[0]
      end
    end

    def valid_placement?(surface, x_position, y_position)
      surface.valid_position?(x_position, y_position)
    end

    def valid_heading?(heading)
      heading ? @all_headings.include?(heading.downcase.to_sym): false
    end 

end