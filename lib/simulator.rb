require_relative 'validations'


# Simulation class for managing input and command delagation
class Simulator

  include Validations

  attr_reader :robot, :surface

  def initialize(surface, robot)
    @robot = robot
    @surface = surface
    set_actions
  end

  # method for executing commands on the robot
  def execute_command(command)
    command_array = command != '' ? command.split : []
    action = command_array[0]
    arguments = command_array.length>1 ?  command_array[1].split(',') : []
    if valid_action?(action)
      @actions[action.downcase.to_sym].call(arguments)
    end
  end

  private
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

    def report_robot_location
      if @robot.report_location 
        puts @robot.report_location
        true
      end
    end

    def set_actions
      @actions = {
        :place => lambda {|args| place_robot(args)},
        :left => lambda {|args| @robot.rotate_left},
        :right => lambda {|args| @robot.rotate_right},
        :move => lambda {|args| @robot.move_forward},
        :report => lambda {|args| report_robot_location},
      }
    end
end