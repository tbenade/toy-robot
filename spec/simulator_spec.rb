require_relative '../lib/simulator'
require_relative '../lib/robot'
require_relative '../lib/table'

describe Simulator do

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
  
    context 'intialized simulator with nil table and robot' do
      subject(:simulator) {Simulator.new(nil, nil)}
      
      it 'should return false for a valid PLACE command' do
        expect(simulator.execute_command("PLACE 0,0,NORTH")).to be false
      end
    end

    context 'intialized simulator with vaild table nil robot' do
      subject(:simulator) {Simulator.new(Table.new(5,5), nil)}
      
      it 'should return false for a valid PLACE command' do
        expect(simulator.execute_command("PLACE 0,0,NORTH")).to be false
      end
    end

    context 'intialized simulator with nil table valid robot' do
      subject(:simulator) {Simulator.new(nil, Robot.new)}
      
      it 'should return false for a valid PLACE command' do
        expect(simulator.execute_command("PLACE 0,0,NORTH")).to be false
      end
    end

    context 'intialized simulator with valid table and robot' do
      let(:output_stream){double("output_stream", :puts => nil)}
      subject(:simulator) {Simulator.new(table, robot, output_stream)}

      it 'successful place' do
        expect(simulator.execute_command("place 0,0,NORTH")).to be true
      end

      it 'successful place with uppercase' do
        expect(simulator.execute_command("PLACE 0,0,NORTH")).to be true
      end

      it 'successful place with lowercase' do
        expect(simulator.execute_command("PLACE 0,0,NORTH".downcase)).to be true
      end

      it 'ignores invalid place command - position' do
        expect(simulator.execute_command("place defunkt, defunkt, NORTH")).to be false
      end

      it 'ignores invalid place command - heading' do
        expect(simulator.execute_command("place 0, 0,defunkt")).to be false
      end

      it 'ignores invalid place command with no arguments' do
        expect(simulator.execute_command("place")).to be false
      end

      it 'should move' do
        simulator.execute_command("PLACE 0,0,NORTH")
        expect(simulator.execute_command("MOVE")).to be true
      end

      it 'performs scenario A of specification' do
        commands = ['PLACE 0,0,NORTH','MOVE','REPORT']
        commands.each do |command|
          simulator.execute_command(command)
        end
        expect(output_stream).to receive(:puts).with("0,1,NORTH")
        simulator.execute_command('REPORT')
      end

      it 'performs scenario B of specification' do
        commands = ['PLACE 0,0,NORTH','LEFT','REPORT']
        commands.each do |command|
          simulator.execute_command(command)
        end
        expect(output_stream).to receive(:puts).with("0,0,WEST")
        simulator.execute_command('REPORT')
      end

      it 'performs scenario C of specification' do
        commands = ['PLACE 1,2,EAST','MOVE','MOVE','LEFT','MOVE','REPORT']
        commands.each do |command|
          simulator.execute_command(command)
        end
        expect(output_stream).to receive(:puts).with("3,3,NORTH")
        simulator.execute_command('REPORT')
      end
    end

    context 'robot placed' do
      let(:output_stream){double("output_stream", :puts => nil)}
      subject(:simulator) {
        simulator =  Simulator.new(table, robot, output_stream)
        simulator.execute_command("PLACE 0,0,EAST")
        simulator
      }

      it 'reports location when asked' do
        expect(output_stream).to receive(:puts)
        simulator.execute_command("REPORT")
      end
    end
  end
end