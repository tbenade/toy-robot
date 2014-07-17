require_relative 'validations'


# Simulation class for managing input and command delagation
class Simulator

  include Validations

  attr_reader :robot, :surface

  def initialize(surface, robot, output_stream=$stdout)
    @robot = robot
    @surface = surface
    @output_stream = output_stream
    set_actions
  end

  # method for executing commands on the robot
  def execute_command(command)
    action, arguments = command.split
    arguments = arguments.nil? ? [] : arguments.split(',')
    if valid_action?(action) && (internal_state_valid?)
      @actions[action.downcase.to_sym].call(arguments)
    else
      false
    end
  end

  private
    def internal_state_valid?
      !!@robot && !!@surface
    end

    def valid_action?(action)
      return false if action.nil? || action.empty?
      @actions[action.strip.downcase.to_sym]
    end

    def place_robot(arguments)
      return false unless @robot && @surface # if we have no robot or surface do nothing

      if arguments.length == 3 && integer?(arguments[0]) && integer?(arguments[1])
        @robot.place(@surface, arguments[0].to_i, arguments[1].to_i, arguments[2])
      else
        false
      end
    end

    def set_actions
      #return unless @robot
      @actions = {
        :place => lambda {|args| place_robot(args)},
        :left => lambda {|args| @robot.rotate_left},
        :right => lambda {|args| @robot.rotate_right},
        :move => lambda {|args| @robot.move_forward},
        :report => lambda {|args| @output_stream.puts @robot.report_location; @robot.report_location},
      }
    end
end