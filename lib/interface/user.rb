module Interface

  class User < Base

    include Actions::User

    def get_user_action
      @selected_action = @prompt.select('What do you want to do? : ', SUPPORTED_ACTION_LIST)
    end

    def get_user_action_data
      return if @selected_action.nil?

      fetch_data(@selected_action)
    end


    def display_receipt(receipt)
      @prompt.ok('Successfully Purchased!')
      display_data(receipt_table_data(receipt))
    end

    private

    def receipt_table_data(receipt_json)
      [['Product Name', 'Price', 'Quantity Purchased', 'Cash Given', 'Balance Returned'],
      [receipt_json[:product_name],
       receipt_json[:bill],
       receipt_json[:quantity],
       receipt_json[:cash_given],
       receipt_json[:balance_returned],
      ]]
    end

    def fetch_data(action)
      case action
      when PLACE_ORDER
        handle_place_order
      end
    end

    def handle_place_order
      begin
        @action_data = @prompt.collect do
          key(:name).select('Select product :', UserService.menu_choices)

          key(:quantity).ask('Quantity :', convert: :int)

          key(:cash).ask('Cash :', convert: :float)
        end
      rescue => e
        raise InvalidInputError
      end
    end

  end
end
