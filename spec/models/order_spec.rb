RSpec.describe Order do

  it 'raises validation error if quantity is not present' do
    order = Order.new(product_id: 1)

    expect{order.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'raises validation error if quantity is negative' do
    order = Order.new(product_id: 1, quantity: -1)

    expect{order.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

end