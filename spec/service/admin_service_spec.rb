RSpec.describe AdminService do

  it 'fetches all registered product names' do
    Product.new('name': 'product-1', price: '100').save!
    Product.new('name': 'product-2', price: '100').save!
    Product.new('name': 'product-3', price: '100').save!

    expect(AdminService.registered_products).to eq(['product-1', 'product-2', 'product-3'])
  end

  context 'Product Registration' do
    let(:data) do
      {'name': 'product-1', 'price': 100}
    end

    it 'registers a new product' do
      AdminService.register_product!(data)

      expect(Product.count).to eq(1)
      expect(AdminService.registered_products).to eq(['product-1'])
    end

    it 'creates an inventory record for the product' do
      AdminService.register_product!(data)

      expect(Inventory.count).to eq(1)
      expect(Inventory.first.product.name).to eq('product-1')
    end

    it 'raises DuplicateProductError on registering product with duplicate names' do
      AdminService.register_product!(data)
      expect{AdminService.register_product!({'name': 'product-1', 'price': 100})}.to raise_error(DuplicateProductError)
    end
  end

  context 'Increasing Product Quantity' do
    let(:product_data) do
      {'name': 'product-1', 'price': 100}
    end

    before(:each) do
      AdminService.register_product!(product_data)
    end

    it 'increases quantity of already registered product' do
      AdminService.increase_product_quantity!({'name': 'product-1', 'quantity': 100})

      expect(Product.first.inventory.available).to eq(100)
    end

    it 'raises ProductNotFound error if product is not registered' do
      expect{AdminService.increase_product_quantity!({'name': 'product-2', 'quantity': 100})}.to raise_error(ProductNotFoundError)
    end
  end

  context 'Decreasing Product Quantity' do
    let(:product_data) do
      {'name': 'product-1', 'price': 100}
    end

    before(:each) do
      AdminService.register_product!(product_data)
      AdminService.increase_product_quantity!({'name': 'product-1', 'quantity': 100})
    end

    it 'decreases quantity of already registered product' do
      AdminService.decrease_product_quantity!({'name': 'product-1', 'quantity': 50})

      expect(Product.first.inventory.available).to eq(50)
    end

    it 'raises ProductNotFound error if product is not registered' do
      expect{AdminService.decrease_product_quantity!({'name': 'product-2', 'quantity': 50})}.to raise_error(ProductNotFoundError)
    end

    it 'raises NotEnoughProductAvailable error if product quantity is too less' do
      expect{AdminService.decrease_product_quantity!({'name': 'product-1', 'quantity': 101})}.to raise_error(NotEnoughProductAvailableError)
    end
  end

  context 'Add change' do
    let(:data) do
      {'change_type': '£1', 'quantity': 100}
    end

    before(:each) do
      Denomination.create!('change_type': '£1')
    end

    it 'increases quantity of denomination if denomination is present' do
      AdminService.add_change!(data)

      expect(Denomination.find_by_change_type('£1').quantity).to eq(100)
    end

    it 'raises InvalidDenominationError if denomination type is unsupported' do
      expect{AdminService.add_change!({'change_type': '£2', 'quantity': 100})}.to raise_error(InvalidDenominationError)
    end
  end

  context 'Remove change' do
    let(:data) do
      {'change_type': '£1', 'quantity': 100}
    end

    before(:each) do
      Denomination.create!('change_type': '£1')
      AdminService.add_change!(data)
    end

    it 'decreases quantity of denomination if denomination is present' do
      AdminService.remove_change!({'change_type': '£1', 'quantity': 50})

      expect(Denomination.find_by_change_type('£1').quantity).to eq(50)
    end

    it 'raises NotEnoughChange errror is available quantity of denomination is too less' do
      expect{AdminService.remove_change!({'change_type': '£1', 'quantity': 500})}.to raise_error(NotEnoughChange)
    end

    it 'raises InvalidDenominationError if denomination type is unsupported' do
      expect{AdminService.remove_change!({'change_type': '£2', 'quantity': 100})}.to raise_error(InvalidDenominationError)
    end
  end
end