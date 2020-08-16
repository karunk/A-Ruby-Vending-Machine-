RSpec.describe Money do

  it 'extracts Pounds from money decimal' do
    money = Money.new(10.34)

    expect(money.pound).to eq(10)
  end

  it 'extracts Pence from money decimal' do
    money = Money.new(10.34)

    expect(money.pence).to eq(34)
  end

  it 'displays information in json' do
    money = Money.new(10.34)

    expect(money.as_json).to eq({:pence=>34, :pound=>10})
  end

  it 'displays information in as a string' do
    money = Money.new(10.34)

    expect(money.display).to eq('£10.34')
  end
end