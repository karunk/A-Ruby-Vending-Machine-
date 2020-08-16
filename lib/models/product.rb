class Product < ActiveRecord::Base
  has_one :inventory
  has_many :orders

  validates :name, presence: true, uniqueness: {case_insensitive: true}
  validates :price, presence: true

end