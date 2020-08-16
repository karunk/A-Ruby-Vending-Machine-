class Money

  attr_reader :pound, :pence

  def initialize(money_in_decimal)
    @money_in_decimal = money_in_decimal
    @pound = get_pounds
    @pence = get_pences
  end

  def as_json
    {'pound': @pound, 'pence': @pence}
  end

  def display
    "£#{@pound}.#{@pence}"
  end

  private

  def get_pences
    fraction = (@money_in_decimal - @money_in_decimal.to_i).round(2)
    fraction.to_s.split('.')[1].to_i
  end

  def get_pounds
    @money_in_decimal.to_i
  end
end