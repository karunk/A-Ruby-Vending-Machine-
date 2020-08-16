module Actions
  '''
  Definitions and input validations of all actions
  available to the user
  '''
  module User
    PLACE_ORDER = 'Place an order'.freeze

    SUPPORTED_ACTION_LIST = [
        PLACE_ORDER
    ].freeze

    PLACE_ORDER_KEYS = %i[name quantity cash].freeze

    def validate_place_order_data!(data)
      raise InvalidInputError unless PLACE_ORDER_KEYS.all? {|s| data.key? s}
      raise InvalidInputError unless !data[:quantity].nil? && data[:quantity].is_a?(Numeric)
      raise InvalidInputError unless !data[:cash].nil? && data[:cash].is_a?(Numeric)
    end

  end
end