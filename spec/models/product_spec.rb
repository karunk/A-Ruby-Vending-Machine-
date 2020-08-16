RSpec.describe Product do

  it 'raises validation error if product name is not unique' do
    Product.create!(name: 'some-name', price: 100)

    expect{Product.create!(name: 'some-name', price: 200)}.to raise_error(ActiveRecord::RecordInvalid)
  end

end