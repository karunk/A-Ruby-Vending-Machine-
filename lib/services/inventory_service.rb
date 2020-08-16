class InventoryService
  class << self

    NAME = 'Name'.freeze
    PRICE = 'Price'.freeze
    QUANTITY = 'Quantity'.freeze

    def register_product!(name, price)
      raise DuplicateProductError if Product.where(name: name).present?

      product = Product.new(name: name, price: price)
      product.build_inventory
      product.save!
    end

    def increase_product_quantity!(name, quantity)
      product = Product.find_by_name(name)
      raise ProductNotFoundError if product.nil?

      product_inventory = product.inventory
      product_inventory.with_lock do
        product_inventory.increment!(:available, quantity)
      end
    end

    def decrease_product_quantity!(name, quanitity)
      product = Product.find_by_name(name)
      raise ProductNotFoundError if product.nil?

      product_inventory = product.inventory
      raise NotEnoughProductAvailableError if product_inventory.available < quanitity

      product_inventory.with_lock do
        product_inventory.decrement!(:available, quanitity)
      end
    end

    def display_inventory
      inventory_data = [[NAME, PRICE, QUANTITY]]
      products = Product.includes(:inventory)
      products.each do |p|
        inventory_data << [p.name, p.price, p.inventory.available]
      end
      inventory_data
    end

    def registered_product_names
      Product.all.pluck(:name)
    end

    def check_availability(name, quanitity=1)
      product = Product.includes(:inventory).find_by_name(name)
      return false if product.nil?

      product.inventory.available >= quanitity
    end

    def fetch_product_info(name)
      product = Product.includes(:inventory).find_by_name(name)
      data = [[NAME, PRICE, QUANTITY]]
      return data if product.nil?

      data << [product.name, product.price, product.inventory.available]
    end
  end
end