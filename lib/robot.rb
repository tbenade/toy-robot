# the class representing the toy that is running around in the simulation

class Robot

  attr_reader :surface, :x_position, :y_position

  def initialize

    @surface = nil
    @x_position = nil
    @y_position = nil
    @is_placed = false    
    @headings = [:north, :east, :south, :west]
  end

  def place(surface, x_position, y_position, heading)
    if !is_valid_placement?(surface, x_position, y_position) || !is_valid_heading?(heading)
      return false
    end

    @surface = surface
    @x_position = x_position.to_i
    @y_position = y_position.to_i
    set_heading(heading)
    @is_placed = true
  end

  def move_forward
    case heading
    when :north
      place(@surface, @x_position, @y_position+1, heading)
    when :east
      place(@surface, @x_position+1, @y_position, heading)
    when :south
      place(@surface, @x_position, @y_position-1, heading)
    when :west
      place(@surface, @x_position-1, @y_position, heading)
    else
      raise "Invalid heading supplied: " + (heading || "not placed")
    end
  end

  def is_placed?
    @is_placed || false
  end

  def rotate_left
    rotate(-1)
  end

  def rotate_right
    rotate(1)
  end

  def report_location
    is_placed? ? "#{x_position},#{y_position},#{heading.upcase}" : nil
  end 

  def all_headings
    # need a consistent array ideally always north @ zero
    @headings.rotate(@headings.index(:north))
  end

  def heading
    is_placed? ? @headings[0] : nil
  end

  private

    def rotate(rotation)
      @headings.rotate!(rotation)
      @headings[0]
    end

    def set_heading(heading)
      index = @headings.index(heading.downcase.to_sym)
      rotate(index)
    end

    def is_valid_placement?(surface, x_position, y_position)
      surface.valid_position?(x_position, y_position)
    end

    def is_valid_heading?(heading)
      heading ? @headings.include?(heading.downcase.to_sym): false
    end 

end