RSpec.describe OrderService do

  context 'Placing an order' do
    before(:each) do
      load_denominations
      load_products
      Config.load_and_set_settings(Config.setting_files('', 'development'))
      allow(Settings).to receive(:[]).and_return('0')
    end

    it 'raises NotEnoughProductAvailableError if not enough product is unavailable in Inventory' do
      expect{OrderService.order!('some-name', 100, 100)}.to raise_error(NotEnoughProductAvailableError)
    end

    it 'raises NotEnoughChange if Cash Register is unable to dispense change required' do
      expect{OrderService.order!('some-name', 1, 111)}.to raise_error(NotEnoughChange)
    end

    it 'Rollbacks entire transaction if some error occurs' do
      allow_any_instance_of(Inventory).to receive(:decrement!).and_raise(StandardError)

      expect{OrderService.order!('some-name', 1, 111)}.to raise_error(StandardError)

      expect(Denomination.all.as_json).to eq([{:change_type=>"£1", :quantity=>1, :value=>1}, {:change_type=>"£2", :quantity=>1, :value=>2}])
      expect(Product.find_by_name('some-name').inventory.available).to eq(30)
      expect(Order.count).to eq(0)
      expect(Receipt.count).to eq(0)
    end

    it 'Withdraws appropriate amount from cash register' do
      OrderService.order!('some-name', 1, 101)

      expect(Denomination.all.as_json).to eq([{:change_type=>"£2", :quantity=>1, :value=>2}, {:change_type=>"£1", :quantity=>0, :value=>1}])
    end

    it 'Decrements product quantity from inventory' do
      OrderService.order!('some-name', 1, 101)

      expect(Product.find_by_name('some-name').inventory.available).to eq(29)
    end

    it 'Generates a receipt for the order' do
      receipt = OrderService.order!('some-name', 1, 101)

      expect(Order.count).to eq(1)
      expect(Receipt.count).to eq(1)
      expect(receipt.as_json).to eq({:balance_returned=>1.0, :bill=>100.0, :cash_given=>101.0, :product_name=>"some-name", :quantity=>1})
    end
  end

  def load_denominations
    Denomination.create!('change_type': '£1')
    Denomination.create!('change_type': '£2')
    CashRegisterService.add_change!('£1', 1)
    CashRegisterService.add_change!('£2', 1)
  end

  def load_products
    InventoryService.register_product!('some-name', 100)
    InventoryService.increase_product_quantity!('some-name', 30)
  end

end