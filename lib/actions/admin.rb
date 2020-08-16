module Actions
  '''
  Definitions and input validations of all actions
  available to the administrator
  '''
  module Admin
    NEW_PRODUCT_REG = 'Register new product'.freeze
    ADD_PRODUCT_QUANTITY = 'Add product quantity'.freeze
    DECREASE_PRODUCT_QUANTITY = 'Decrease product quantity'.freeze
    ADD_DENOMINATION_QUANTITY = 'Add Denomination Quantity'.freeze
    DECREASE_DENOMINATION_QUANTITY = 'Remove Denomination Quantity'.freeze
    DISPLAY_PRODUCTS = 'Display Products'.freeze
    DISPLAY_CASH_REGISTER = 'Display Cash Register'.freeze

    SUPPORTED_ACTION_LIST = [
        NEW_PRODUCT_REG,
        ADD_PRODUCT_QUANTITY,
        DECREASE_PRODUCT_QUANTITY,
        ADD_DENOMINATION_QUANTITY,
        DECREASE_DENOMINATION_QUANTITY,
        DISPLAY_PRODUCTS,
        DISPLAY_CASH_REGISTER
    ].freeze

    NEW_PRODUCT_REG_KEYS = %i[name price].freeze
    ADD_PRODUCT_QUANTITY_KEYS = %i[name quantity].freeze
    DECREASE_PRODUCT_QUANTITY_KEYS = %i[name quantity].freeze
    ADD_DENOMINATION_QUANTITY_KEYS = %i[change_type quantity].freeze
    DECREASE_DENOMINATION_QUANTITY_KEYS = %i[change_type quantity].freeze

    def validate_new_reg_product_data!(data)
      raise InvalidInputError unless NEW_PRODUCT_REG_KEYS.all? {|s| data.key? s}
      raise InvalidInputError unless !data[:price].nil? && data[:price].is_a?(Numeric)
    end

    def validate_add_product_data!(data)
      raise InvalidInputError unless ADD_PRODUCT_QUANTITY_KEYS.all? {|s| data.key? s}
      raise InvalidInputError unless !data[:quantity].nil? && data[:quantity].is_a?(Numeric)
    end

    def validate_decrease_product_data!(data)
      raise InvalidInputError unless DECREASE_PRODUCT_QUANTITY_KEYS.all? {|s| data.key? s}
      raise InvalidInputError unless !data[:quantity].nil? && data[:quantity].is_a?(Numeric)
    end

    def validate_add_denomination_data!(data)
      raise InvalidInputError unless ADD_DENOMINATION_QUANTITY_KEYS.all? {|s| data.key? s}
      raise InvalidInputError unless !data[:quantity].nil? && data[:quantity].is_a?(Numeric)
    end

    def validate_remove_denomination_data!(data)
      raise InvalidInputError unless DECREASE_DENOMINATION_QUANTITY_KEYS.all? {|s| data.key? s}
      raise InvalidInputError unless !data[:quantity].nil? && data[:quantity].is_a?(Numeric)
    end
  end
end