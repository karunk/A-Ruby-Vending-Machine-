RSpec.describe CashRegisterService do

  context 'Remove change' do
    before(:each) do
      Denomination.create!('change_type': '£1')
      CashRegisterService.add_change!('£1', 100)
    end

    it 'decreases quantity of denomination if denomination is present' do
      CashRegisterService.withdraw_change!('£1', 50)

      expect(Denomination.find_by_change_type('£1').quantity).to eq(50)
    end

    it 'raises NotEnoughChange errror is available quantity of denomination is too less' do
      expect{CashRegisterService.withdraw_change!('£1', 500)}.to raise_error(NotEnoughChange)
    end

    it 'raises InvalidDenominationError if denomination type is unsupported' do
      expect{CashRegisterService.withdraw_change!('£2', 100)}.to raise_error(InvalidDenominationError)
    end
  end

  context 'Add change' do
    before(:each) do
      Denomination.create!('change_type': '£1')
    end

    it 'increases quantity of denomination if denomination is present' do
      CashRegisterService.add_change!('£1', 100)

      expect(Denomination.find_by_change_type('£1').quantity).to eq(100)
    end

    it 'raises InvalidDenominationError if denomination type is unsupported' do
      expect{CashRegisterService.add_change!('£2', 100)}.to raise_error(InvalidDenominationError)
    end
  end

  context 'Calculating Balance' do
    before(:each) do
      load_denominations
    end

    it 'raises InvalidInputError if amount to be withdrawn is not Numeric' do
      expect{CashRegisterService.calculate_balance('some-money', 100)}.to raise_error(InvalidInputError)
    end

    it 'returns balance to be returned' do
      expect(CashRegisterService.calculate_balance(10.36, 15)).to eq(4.64)
    end
  end

  context 'Computing denominations to return' do
    before(:each) do
      load_denominations
    end

    it 'returns denominations hash when cash register has enough change - £10.32' do
      denom_hash = CashRegisterService.compute_denominations_to_return(10.32)
      expect(denom_hash).to eq({"10p"=>3, "2p"=>1, "£2"=>5})
    end

    it 'returns denominations hash when cash register has enough change - 30.32' do
      denom_hash = CashRegisterService.compute_denominations_to_return(30.32)
      expect(denom_hash).to eq({"10p"=>3, "2p"=>1, "£1"=>10, "£2"=>10})
    end

    it 'returns denominations hash when cash register has enough change - 30.36' do
      denom_hash = CashRegisterService.compute_denominations_to_return(30.36)
      expect(denom_hash).to eq({"10p"=>3, "1p"=>2, "2p"=>2, "£1"=>10, "£2"=>10})
    end

    it 'returns denominations hash when cash register has enough change - £30.31' do
      denom_hash = CashRegisterService.compute_denominations_to_return(30.31)
      expect(denom_hash).to eq({"10p"=>3, "1p"=>1, "2p"=>0, "£1"=>10, "£2"=>10})
    end

    it 'raises NotEnoughChange exception when cash register does not have enough change' do
      expect{CashRegisterService.compute_denominations_to_return(300.31)}.to raise_error(NotEnoughChange)
    end


    it 'raises NotEnoughChange exception when cash register does not have enough change' do
      expect{CashRegisterService.compute_denominations_to_return(30.37)}.to raise_error(NotEnoughChange)
    end
  end

  context 'Withdrawing from cash register' do
    before(:each) do
      load_denominations
    end

    it 'withdraws appropriate amount from cash register' do
      CashRegisterService.withdraw(30.30)

      expect(Denomination.all.as_json).to eq([{:value=>2, :change_type=>"£2", :quantity=>0},
                                              {:value=>1, :change_type=>"£1", :quantity=>0},
                                              {:value=>0.1, :change_type=>"10p", :quantity=>3},
                                              {:value=>0.02, :change_type=>"2p", :quantity=>1},
                                              {:value=>0.01, :change_type=>"1p", :quantity=>1}])

    end
  end

  def load_denominations
    Denomination.create!('change_type': '£1')
    Denomination.create!('change_type': '£2')
    Denomination.create!('change_type': '10p')
    Denomination.create!('change_type': '2p')
    Denomination.create!('change_type': '1p')
    CashRegisterService.add_change!('£1', 10)
    CashRegisterService.add_change!('£2', 10)
    CashRegisterService.add_change!('10p', 3)
    CashRegisterService.add_change!('2p', 2)
    CashRegisterService.add_change!('1p', 2)
  end
end