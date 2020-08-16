RSpec.describe Receipt do

  it 'raises validation error if cash is not numeric' do
    expect{Receipt.create!(cash_given: 'some-cash', bill: 200, balance_returned: 0)}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'raises validation error if bill is not numeric' do
    expect{Receipt.create!(cash_given: 100, bill: 'some-bill', balance_returned: 0)}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'render appropriat information in as_json' do
    product = Product.create!(name: 'some-name', price: 100)
    order = Order.create!(product_id: product.id, quantity: 1)
    receipt = Receipt.create!(cash_given: 100, bill: 20, balance_returned: 0, order_id: order.id)

    expect(receipt.as_json).to eq({:balance_returned=>0.0, :bill=>20.0, :cash_given=>100.0, :product_name=>"some-name", :quantity=>1})
  end
end