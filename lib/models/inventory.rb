class Inventory < ActiveRecord::Base
  belongs_to :product

  def available?
    available.positive?
  end

end