require_relative '../lib/robot'

describe Robot do

  # creates a surface with a default valid_position? == true
  def create_surface(valid_position=true)
    double("surface", :height => rand(1..10), :width => rand(1..10), :valid_position? => valid_position)
  end

  describe 'intialization' do
    it 'successful' do
      expect(Robot.new).not_to be_nil
    end
  end

  describe 'move_forward' do

    context 'when surface responds true for valid_position?' do
      let(:surface){create_surface}
      subject(:robot){Robot.new}
    
      it 'moves north' do
        robot.place(surface, 0, 0, :north)
        expect(robot.move_forward).to eq true
      end
      it 'moves east' do
        robot.place(surface, 0, 0, :east)
        expect(robot.move_forward).to eq true
      end
      it 'moves south' do
        robot.place(surface, 1, 1, :south)
        expect(robot.move_forward).to eq true
      end
      it 'moves west' do
        robot.place(surface, 1, 1, :west)
        expect(robot.move_forward).to eq true
      end
    end
    
    context 'when surface responds false for valid_position?' do
      subject(:robot){
        robot = Robot.new
        robot.place(create_surface, 0, 0, :south)
        robot
      }
 
      it 'ignores invalid move command' do
        # setup surface to return the invalid position
        allow(robot.surface).to receive(:valid_position?).and_return(false)
        expect(robot.move_forward).to eq false
      end
    end

  end

  describe '#place' do

    let(:surface){create_surface}
    subject(:robot){Robot.new}

    it 'successfully placed' do
      expect(robot.place(surface, 0, 0, :north)).to eq true
    end

    it 'fails placement, invalid heading' do
      expect(robot.place(surface, 0, 0, "defunkt")).to eq false
    end

    it 'successfully placed in all headings' do
      robot.all_headings.each do |heading|
        expect(robot.place(surface, 0, 0, heading)).to eq true
      end
    end

    it 'fails placement, invalid grid location' do
      allow(surface).to receive(:valid_position?).with(-1,-1).and_return(false)
      expect(robot.place(surface, -1, -1, :north)).to eq false
    end
  end

  describe '#placed?' do

    let(:surface){create_surface}
    subject(:robot){Robot.new}

    it 'false when not placed' do
      expect(robot.placed?).to be false
    end

    it 'true when placed' do
      robot.place(surface, 0, 0, :north)
      expect(robot.placed?).to be true
    end

    it 'false when placed invalid location' do
      allow(surface).to receive(:valid_position?).with(-1,-1).and_return(false)
      robot.place(surface, -1, -1, :north)
      expect(robot.placed?).to be false
    end

    it 'false when placed invalid heading' do
      allow(surface).to receive(:valid_position?).with(0,0).and_return(true)
      robot.place(surface, 0, 0, "defunkt")
      expect(robot.placed?).to be false
    end
  end

  describe 'rotate_left' do
    
    let(:surface){create_surface}
    subject(:robot){Robot.new}

    it 'rotates left successfully' do
      robot.place(surface, 0, 0, :north)
      robot.rotate_left
      expect(robot.heading).to be :west
    end

    it 'rotating unplaced has no effect' do
      robot.rotate_left
      expect(robot.heading).to be_nil
    end
  end

  describe 'rotate_right' do

    let(:surface){create_surface}
    subject(:robot){Robot.new}

    it 'rotates left successfully' do
      robot.place(surface, 0, 0, :south)
      robot.rotate_right
      expect(robot.heading).to be :west
    end

    it 'rotating unplaced has no effect' do
      robot.rotate_right
      expect(robot.heading).to be_nil
    end
  end

  describe '#report_location' do

    let(:surface){create_surface} 
    subject(:robot){Robot.new}

    it 'reports the current location' do
      allow(surface).to receive(:valid_position?).with(surface.width, surface.height).and_return(true)
      heading = :south
      robot.place(surface, surface.width, surface.height, heading)
      expect(robot.report_location).to eq "#{robot.surface.width},#{robot.surface.height},#{robot.heading.upcase}"
    end

    it 'unplaced report no location' do
      allow(surface).to receive(:valid_position?).with(nil,nil).and_return(false)
      expect(robot.report_location).to be_nil
    end
  end
end