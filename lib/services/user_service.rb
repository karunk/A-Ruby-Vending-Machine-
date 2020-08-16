class UserService
  class << self

    def place_order!(data)
      receipt = OrderService.order!(data[:name], data[:quantity], data[:cash])
      receipt
    end

    def display_inventory
      InventoryService.display_inventory
    end

    def menu_choices
      choices = []
      products = Product.includes(:inventory)
      products.each do |p|
        choices << { name: p.name, disabled: !p.inventory.available? }
      end
      choices
    end

  end
end