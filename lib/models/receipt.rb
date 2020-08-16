class Receipt < ActiveRecord::Base
  belongs_to :order

  validates :bill, presence: true
  validates :cash_given, presence: true
  validates :bill, numericality: { greater_than_or_equal_to: 0 }
  validates :cash_given, numericality: { greater_than_or_equal_to: 0 }

  def as_json
    {
        :cash_given => cash_given,
        :bill => bill,
        :balance_returned => balance_returned,
        :product_name => order.product.name,
        :quantity => order.quantity
    }
  end

end
