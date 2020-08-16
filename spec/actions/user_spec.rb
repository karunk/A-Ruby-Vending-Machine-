RSpec.describe Actions::User do

  before(:each) do
    @dummy_class = Class.new
    @dummy_class.extend(Actions::User)
    @data = {}
  end

  context 'Placing an order' do
    it 'raises InvalidInputError if data does not have PRODUCT_NAME' do
      @data[:quantity] = 100
      @data[:cash] = 100
      expect{@dummy_class.validate_place_order_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains PRODUCT_NAME' do
      @data[:name] = 'a product'
      @data[:quantity] = 100
      @data[:cash] = 100
      expect{@dummy_class.validate_place_order_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if data does not have QUANTITY' do
      @data[:name] = 'a product'
      @data[:cash] = 100
      expect{@dummy_class.validate_place_order_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains QUANTITY' do
      @data[:quantity] = 100
      @data[:name] = 'a product'
      @data[:cash] = 100
      expect{@dummy_class.validate_place_order_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if quantity is not numeric' do
      @data[:price] = '100'
      @data[:name] = 'a product'
      expect{@dummy_class.validate_place_order_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'raises InvalidInputError if data does not have CASH' do
      @data[:name] = 'a product'
      @data[:quantity] = 100
      expect{@dummy_class.validate_place_order_data!(@data)}.to raise_error(InvalidInputError)
    end
  end

end