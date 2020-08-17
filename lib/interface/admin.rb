'''
Responsible for rendering appropriate messages in the command prompt
during administrative actions
'''
module Interface

  class Admin < Base

    include Actions::Admin

    def display_available_actions
      @selected_action = @prompt.select('What do you want to do? (Scroll down using arrow keys to see all actions): ', SUPPORTED_ACTION_LIST)
    end

    def get_user_action_data
      return if @selected_action.nil?

      fetch_data(@selected_action)
    end

    def display_new_product(data)
      @prompt.ok('New product registered!')
      display_data(data)
    end

    def display_product_addition(data)
      @prompt.ok("Stock replenished!")
      display_data(data)
    end

    def display_product_removal(data)
      @prompt.ok("Stock decreased!")
      display_data(data)
    end

    def display_denomination_addition(data)
      @prompt.ok("Denomination quantity increased!")
      display_data(data)
    end

    def display_denomination_removal(data)
      @prompt.ok("Denomination quantity decreased!")
      display_data(data)
    end

    private

    def fetch_data(action)
      begin
        case action
        when NEW_PRODUCT_REG
          handle_new_product_registration
        when ADD_PRODUCT_QUANTITY
          handle_add_product_quantity
        when DECREASE_PRODUCT_QUANTITY
          handle_decrease_product_quantity
        when ADD_DENOMINATION_QUANTITY
          handle_add_change
        when DECREASE_DENOMINATION_QUANTITY
          handle_remove_change
        end
      rescue => e
        raise InvalidInputError
      end
    end

    def handle_new_product_registration
      @action_data = @prompt.collect do
        key(:name).ask('Enter a product name :')

        key(:price).ask('Price (£) :', convert: :float)
      end
      validate_new_reg_product_data!(@action_data)
    end

    def handle_add_product_quantity
      @action_data = @prompt.collect do
        key(:name).select('Select product to modify :', AdminService.registered_products)

        key(:quantity).ask('Quantity to be added :', convert: :int)
      end
      validate_add_product_data!(@action_data)
    end

    def handle_decrease_product_quantity
      @action_data = @prompt.collect do
        key(:name).select('Select product to modify :', AdminService.registered_products)

        key(:quantity).ask('Quantity to be removed :', convert: :int)
      end
      validate_decrease_product_data!(@action_data)
    end

    def handle_add_change
      @action_data = @prompt.collect do
        key(:change_type).select('Select denomination :', Settings[:supported_denominations].split(','))

        key(:quantity).ask('Quantity to be added :', convert: :int)
      end
      validate_add_denomination_data!(@action_data)
    end

    def handle_remove_change
      @action_data = @prompt.collect do
        key(:change_type).select('Select denomination :', Settings[:supported_denominations].split(','))

        key(:quantity).ask('Quantity to be removed :', convert: :int)
      end
      validate_remove_denomination_data!(@action_data)
    end

  end
end
