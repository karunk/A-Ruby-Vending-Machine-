RSpec.describe Denomination do

  context 'as_json for' do
    it '1p' do
      Denomination.create!('change_type': '1p', 'quantity': 5)

      expect(Denomination.last.as_json).to eq({:change_type=>"1p", :quantity=>5, :value=>0.01})
    end

    it '2p' do
      Denomination.create!('change_type': '2p', 'quantity': 5)

      expect(Denomination.last.as_json).to eq({:change_type=>"2p", :quantity=>5, :value=>0.02})
    end

    it '5p' do
      Denomination.create!('change_type': '5p', 'quantity': 5)

      expect(Denomination.last.as_json).to eq({:change_type=>"5p", :quantity=>5, :value=>0.05})
    end

    it '10p' do
      Denomination.create!('change_type': '10p', 'quantity': 5)

      expect(Denomination.last.as_json).to eq({:change_type=>"10p", :quantity=>5, :value=>0.1})
    end

    it '20p' do
      Denomination.create!('change_type': '20p', 'quantity': 5)

      expect(Denomination.last.as_json).to eq({:change_type=>"20p", :quantity=>5, :value=>0.2})
    end

    it '50p' do
      Denomination.create!('change_type': '50p', 'quantity': 5)

      expect(Denomination.last.as_json).to eq({:change_type=>"50p", :quantity=>5, :value=>0.5})
    end

    it '£1' do
      Denomination.create!('change_type': '£1', 'quantity': 5)

      expect(Denomination.last.as_json).to eq({:change_type=>"£1", :quantity=>5, :value=>1})
    end
  end

end