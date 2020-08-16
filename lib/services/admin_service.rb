class AdminService
  class << self

    def cash_register
      denom_data = [['Denomination','Quantity']]
      Denomination.all.each do |d|
        denom_data << [d.change_type, d.quantity]
      end
      denom_data
    end

    def display_inventory
      InventoryService.display_inventory
    end

    def registered_products
      InventoryService.registered_product_names
    end

    def register_product!(data)
      InventoryService.register_product!(data[:name], data[:price])
    end

    def fetch_product_data(name)
      InventoryService.fetch_product_info(name)
    end

    def increase_product_quantity!(data)
      InventoryService.increase_product_quantity!(data[:name], data[:quantity])
    end

    def decrease_product_quantity!(data)
      InventoryService.decrease_product_quantity!(data[:name], data[:quantity])
    end

    def remove_change!(data)
      CashRegisterService.withdraw_change!(data[:change_type], data[:quantity])
    end

    def add_change!(data)
      CashRegisterService.add_change!(data[:change_type], data[:quantity])
    end
  end
end