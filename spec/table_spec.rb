require_relative '../lib/table'

describe Table do
  
  describe 'intialization' do

    context 'correctly intialized table' do
      let(:width){5}
      let(:height){5}
      subject(:table){Table.new(width, height)}

      it 'successful' do
        expect(table).not_to be_nil
      end

      it 'width correctly set' do
        expect(table.width).to be width
      end

      it 'height correctly set' do
        expect(table.height).to be height
      end
    end
    
  end

  describe '#valid_position?' do
    
    context 'incorrectly intialized table' do
      subject(:table){Table.new(nil, nil)}

      it 'returns false' do
        expect(table.valid_position?(0, 0)).to be false
      end
    end

    context 'correctly intialized table' do
      subject(:table){Table.new(rand(1..10),rand(1..10))}
   
      it 'false for an invalid max position' do
        expect(table.valid_position?(table.width+1, table.height+1)).to be false
      end

      it 'false for an invalid min position' do
        expect(table.valid_position?(-1, -1)).to be false
      end

      it 'return false for non integer arguments' do
        expect(table.valid_position?("a", "b")).to be false
      end

      it 'return true for 0,0 position' do
        expect(table.valid_position?(0, 0)).to be true
      end    

      it 'return true for a valid position' do
        expect(table.valid_position?(table.width-1, table.height-1)).to be true
      end
    end
  end  
end