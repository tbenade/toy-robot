require_relative '../lib/simulator'
require_relative '../lib/robot'
require_relative '../lib/table'

describe Simulator do

  let(:table_width){5}
  let(:table_height){5}
  let(:robot){Robot.new}
  let(:table){Table.new(5,5)}

  describe 'intialization' do
    let(:simulator) {Simulator.new(table, robot)}

    it 'successful' do
      expect(simulator.robot).to eq robot
    end

    it 'fails when no arguments supplied' do
      expect{Simulator.new}.to raise_error(ArgumentError)
    end

    it 'fails when no table supplied' do
      expect{Simulator.new(table)}.to raise_error(ArgumentError)
    end

  end

  describe '#execute_command' do
    let(:simulator) {Simulator.new(table, robot)}
    let(:x){rand(0..table_width)}
    let(:y){rand(0..table_height)}

    it 'successful place' do
      simulator.execute_command("place #{x},#{y},NORTH")
      expect(robot.x_position).to eq x
      expect(robot.y_position).to eq y
    end

    it 'with mixed case commands successfully placed' do
      command = "place #{x},#{y},NORTH"
      simulator.execute_command(command)
      expect(robot.x_position).to eq x
      expect(robot.y_position).to eq y
      simulator.execute_command(command.downcase)
      expect(robot.x_position).to eq x
      expect(robot.y_position).to eq y
      simulator.execute_command(command.upcase)
      expect(robot.x_position).to eq x
      expect(robot.y_position).to eq y
      simulator.execute_command(command.capitalize)
      expect(robot.x_position).to eq x
      expect(robot.y_position).to eq y
    end

    it 'ignores invalid place command' do
      x = "defunkt"
      y = "defunkt"
      simulator.execute_command("place #{x},#{y},NORTH")
      expect(robot.x_position).to be_nil
      expect(robot.y_position).to be_nil
    end

    it 'ignores invalid place command with no arguments' do
      simulator.execute_command("place")
      expect(robot.x_position).to be_nil
      expect(robot.y_position).to be_nil
    end
  end

end