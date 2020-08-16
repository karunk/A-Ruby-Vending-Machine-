RSpec.describe BillingService do

  context 'Bill Calculation' do
    before(:each) do
      Config.load_and_set_settings(Config.setting_files('', 'development'))
      InventoryService.register_product!('some-name', 100)
      InventoryService.increase_product_quantity!('some-name', 30)
    end

    it 'Calculates bill for the given product and quanitiy along with tax' do
      allow(Settings).to receive(:[]).and_return('0.15')

      bill_data = BillingService.calculate_bill('some-name', 21)

      expect(bill_data).to eq({:cost=>2100.0, :tax=>315.0, :total_cost=>2415.0})
    end

    it 'raises ProductNotFoundError if product is not registered' do
      allow(Settings).to receive(:[]).and_return('0.15')

      expect{BillingService.calculate_bill('some-other-name', 21)}.to raise_error(ProductNotFoundError)
    end

    it 'raises InvalidInputError if quantity is not an integer' do
      allow(Settings).to receive(:[]).and_return('0.15')

      expect{BillingService.calculate_bill('some-name', 100.12)}.to raise_error(InvalidInputError)
    end
  end

end

