class OrderService
  class << self
    def order!(product_name, quantity, cash)
      product = Product.find_by_name(product_name)
      raise ProductNotFoundError if product.nil?

      raise NotEnoughProductAvailableError unless InventoryService.check_availability(product_name, quantity)

      bill_data = BillingService.calculate_bill(product_name, quantity)
      raise InsufficientAmountError if bill_data[:total_cost] > cash

      balance = CashRegisterService.calculate_balance(bill_data[:total_cost], cash)


      order = nil
      ActiveRecord::Base.transaction do
        order = Order.new(:product_id => product.id,
                          :quantity => quantity)
        order.build_receipt(:bill => bill_data[:total_cost],
                            :cash_given => cash,
                            :balance_returned => balance)
        order.save!
        CashRegisterService.withdraw(cash-bill_data[:total_cost])
        InventoryService.decrease_product_quantity!(product_name, quantity)
      end

      order.receipt
    end
  end
end