RSpec.describe Actions::Admin do

  before(:each) do
    @dummy_class = Class.new
    @dummy_class.extend(Actions::Admin)
    @data = {}
  end

  context 'New product registration' do
    it 'raises InvalidInputError if data does not have PRODUCT_NAME' do
      @data[:price] = 100
      expect{@dummy_class.validate_new_reg_product_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains PRODUCT_NAME' do
      @data[:name] = 'a product'
      @data[:price] = 100
      expect{@dummy_class.validate_new_reg_product_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if data does not have PRICE' do
      @data[:name] = 'a product'
      expect{@dummy_class.validate_new_reg_product_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains PRICE' do
      @data[:price] = 100
      @data[:name] = 'a product'
      expect{@dummy_class.validate_new_reg_product_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if price is not numeric' do
      @data[:price] = '100'
      @data[:name] = 'a product'
      expect{@dummy_class.validate_new_reg_product_data!(@data)}.to raise_error(InvalidInputError)
    end
  end

  context 'Add product quantity' do
    it 'raises InvalidInputError if data does not have PRODUCT_NAME' do
      @data[:quantity] = 100
      expect{@dummy_class.validate_add_product_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains PRODUCT_NAME' do
      @data[:name] = 'a product'
      @data[:quantity] = 100
      expect{@dummy_class.validate_add_product_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if data does not have QUANTITY' do
      @data[:name] = 'a product'
      expect{@dummy_class.validate_add_product_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains QUANTITY' do
      @data[:quantity] = 100
      @data[:name] = 'a product'
      expect{@dummy_class.validate_add_product_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if quantity is not numeric' do
      @data[:quantity] = '100'
      @data[:name] = 'a product'
      expect{@dummy_class.validate_add_product_data!(@data)}.to raise_error(InvalidInputError)
    end
  end

  context 'Decrease product quantity' do
    it 'raises InvalidInputError if data does not have PRODUCT_NAME' do
      @data[:quantity] = 100
      expect{@dummy_class.validate_decrease_product_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains PRODUCT_NAME' do
      @data[:name] = 'a product'
      @data[:quantity] = 100
      expect{@dummy_class.validate_decrease_product_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if data does not have QUANTITY' do
      @data[:name] = 'a product'
      expect{@dummy_class.validate_decrease_product_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains QUANTITY' do
      @data[:quantity] = 100
      @data[:name] = 'a product'
      expect{@dummy_class.validate_decrease_product_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if quantity is not numeric' do
      @data[:quantity] = '100'
      @data[:name] = 'a product'
      expect{@dummy_class.validate_decrease_product_data!(@data)}.to raise_error(InvalidInputError)
    end
  end

  context 'Add Denomination' do
    it 'raises InvalidInputError if data does not have CHANGE_TYPE' do
      @data[:quantity] = 100
      expect{@dummy_class.validate_add_denomination_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains CHANGE_TYPE' do
      @data[:change_type] = 'a product'
      @data[:quantity] = 100
      expect{@dummy_class.validate_add_denomination_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if data does not have QUANTITY' do
      @data[:change_type] = 'a product'
      expect{@dummy_class.validate_add_denomination_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains QUANTITY' do
      @data[:quantity] = 100
      @data[:change_type] = 'a product'
      expect{@dummy_class.validate_add_denomination_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if quantity is not numeric' do
      @data[:quantity] = '100'
      @data[:change_type] = 'a product'
      expect{@dummy_class.validate_add_denomination_data!(@data)}.to raise_error(InvalidInputError)
    end
  end

  context 'Remove Change' do
    it 'raises InvalidInputError if data does not have CHANGE_TYPE' do
      @data[:quantity] = 100
      expect{@dummy_class.validate_remove_denomination_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains CHANGE_TYPE' do
      @data[:change_type] = 'a product'
      @data[:quantity] = 100
      expect{@dummy_class.validate_remove_denomination_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if data does not have QUANTITY' do
      @data[:change_type] = 'a product'
      expect{@dummy_class.validate_remove_denomination_data!(@data)}.to raise_error(InvalidInputError)
    end

    it 'does not raise InvalidInputError if data contains QUANTITY' do
      @data[:quantity] = 100
      @data[:change_type] = 'a product'
      expect{@dummy_class.validate_remove_denomination_data!(@data)}.to_not raise_error
    end

    it 'raises InvalidInputError if quantity is not numeric' do
      @data[:quantity] = '100'
      @data[:change_type] = 'a product'
      expect{@dummy_class.validate_remove_denomination_data!(@data)}.to raise_error(InvalidInputError)
    end
  end
end