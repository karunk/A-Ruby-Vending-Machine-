RSpec.describe InventoryService do

  context 'Product Registration' do
    it 'registers a new product' do
      InventoryService.register_product!('some-name', 100)

      expect(Product.count).to eq(1)
      expect(Product.first.name).to eq('some-name')
    end

    it 'creates an inventory record for the product' do
      InventoryService.register_product!('some-name', 100)

      expect(Inventory.count).to eq(1)
      expect(Inventory.first.product.name).to eq('some-name')
    end

    it 'raises DuplicateProductError on registering product with duplicate names' do
      InventoryService.register_product!('some-name', 100)
      expect{InventoryService.register_product!('some-name', 100)}.to raise_error(DuplicateProductError)
    end
  end

  context 'Increasing Product Quantity' do
    before(:each) do
      InventoryService.register_product!('some-name', 100)
    end

    it 'increases quantity of already registered product' do
      InventoryService.increase_product_quantity!('some-name', 30)

      expect(Product.first.inventory.available).to eq(30)
    end

    it 'raises ProductNotFound error if product is not registered' do
      expect{InventoryService.increase_product_quantity!('some-other-name', 100)}.to raise_error(ProductNotFoundError)
    end
  end

  context 'Decreasing Product Quantity' do
    before(:each) do
      InventoryService.register_product!('some-name', 100)
      InventoryService.increase_product_quantity!('some-name', 30)
    end

    it 'decreases quantity of already registered product' do
      InventoryService.decrease_product_quantity!('some-name', 10)

      expect(Product.first.inventory.available).to eq(20)
    end

    it 'raises ProductNotFound error if product is not registered' do
      expect{InventoryService.decrease_product_quantity!('some-other-name', 30)}.to raise_error(ProductNotFoundError)
    end

    it 'raises NotEnoughProductAvailable error if product quantity is too less' do
      expect{InventoryService.decrease_product_quantity!('some-name', 500)}.to raise_error(NotEnoughProductAvailableError)
    end
  end

  context 'Inventory Display' do
    before(:each) do
      InventoryService.register_product!('product-1', 100)
      InventoryService.increase_product_quantity!('product-1', 30)
      InventoryService.register_product!('product-2', 100)
      InventoryService.increase_product_quantity!('product-2', 30)
    end

    it 'Fetches details of available products' do
      expect(InventoryService.display_inventory).to eq([["Name", "Price", "Quantity"], ["product-1", 100.0, 30], ["product-2", 100.0, 30]])
    end

    it 'Fetches all registered product names' do
      expect(InventoryService.registered_product_names).to eq(["product-1", "product-2"])
    end
  end

  context 'Product Availability' do
    before(:each) do
      InventoryService.register_product!('product-1', 100)
      InventoryService.increase_product_quantity!('product-1', 30)
      InventoryService.register_product!('product-2', 100)
    end

    it 'Informs about available products for specified quantity' do
      expect(InventoryService.check_availability('product-1', 30)).to be true
      expect(InventoryService.check_availability('product-1', 31)).to be false
    end

    it 'Informs about unavailable products for specified quantity' do
      expect(InventoryService.check_availability('product-2', 100)).to be false
    end
  end

end