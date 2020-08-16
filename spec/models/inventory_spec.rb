RSpec.describe Inventory do

  it 'informs about product availability' do
    available_product = Product.new(name: 'some-available-name', price: 'some-price')
    unavailable_product = Product.new(name: 'some-unavailable-name', price: 'some-price')
    available_product.build_inventory(available: 10)
    unavailable_product.build_inventory(available: 0)

    expect(available_product.inventory.available?).to be true
    expect(unavailable_product.inventory.available?).to be false
  end

end