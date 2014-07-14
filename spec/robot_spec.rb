require_relative '../lib/robot'

describe Robot do

  let(:robot){Robot.new}

  # creates a surface with a default valid_position? == true
  def create_surface
    double("surface", :height => rand(1..10), :width => rand(1..10), :valid_position? => true)
  end

  describe 'intialization' do
    it 'successful' do
      robot = Robot.new
      expect(robot).not_to be_nil
    end
  end

  describe 'move_forward' do
    
    let(:surface){create_surface}

    context 'with room to move into' do
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
    
    it 'successfully moves' do
      robot.place(surface, surface.width, surface.height,:south)
      expect(robot.move_forward).to eq true
      expect(robot.y_position).to eq robot.surface.height-1 # as we moved south 1
      expect(robot.x_position).to eq robot.surface.width
    end

    it 'ignores invalid move command' do
      robot.place(surface, 0, 0, :south)
      # setup surface to return the invalid position
      allow(robot.surface).to receive(:valid_position?).and_return(false)
      expect(robot.move_forward).to eq false
      expect(robot.x_position).to eq 0 #check location unchanged
      expect(robot.y_position).to eq 0 #check location unchanged
    end

  end

  describe '#place' do

    let(:surface){create_surface}

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

  describe '#is_placed?' do

    let(:surface){create_surface}

    it 'returns false when not placed' do
      expect(robot.is_placed?).to be false
    end

    it 'returns true when placed' do
      robot.place(surface, 0, 0, :north)
      expect(robot.is_placed?).to be true
    end

    it 'returns false when placed invalid location' do
      allow(surface).to receive(:valid_position?).with(-1,-1).and_return(false)
      robot.place(surface, -1, -1, :north)
      expect(robot.is_placed?).to be false
    end

    it 'returns false when placed invalid heading' do
      allow(surface).to receive(:valid_position?).with(0,0).and_return(true)
      robot.place(surface, 0, 0, "defunkt")
      expect(robot.is_placed?).to be false
    end
  end

  describe 'rotate_left' do
    let(:surface){create_surface}

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