class BillingService
  class << self
    def calculate_bill(name, quantity)
      product = Product.find_by_name(name)
      raise ProductNotFoundError if product.nil?

      raise InvalidInputError unless quantity.is_a? Integer

      cost = product.price * quantity
      bill_data(cost)
    end

    private

    def bill_data(cost)
      tax = calculate_tax(cost)
      { :'total_cost' => cost + tax,
        :'tax' => tax,
        :'cost' => cost }
    end

    def calculate_tax(cost)
      Settings[:tax_percentage].to_f*cost
    end
  end
end