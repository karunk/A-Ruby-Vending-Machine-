class AdminApp < VendingMachineApp

  include Actions::Admin

  def initialize
    @interface = Interface::Admin.new
  end

  def run!
    begin
      @interface.display_available_actions
      @interface.get_user_action_data
      perform!(@interface.selected_action, @interface.action_data)
    rescue => e
      handle_exceptions(e)
    end
    #rerun!
  end

  private

  def perform!(action, action_data)
    case action
    when Actions::Admin::NEW_PRODUCT_REG
      AdminService.register_product!(action_data)
      @interface.display_new_product(AdminService.fetch_product_data(action_data[:name]))

    when Actions::Admin::ADD_PRODUCT_QUANTITY
      AdminService.increase_product_quantity!(action_data)
      @interface.display_product_addition(AdminService.fetch_product_data(action_data[:name]))

    when Actions::Admin::DECREASE_PRODUCT_QUANTITY
      AdminService.decrease_product_quantity!(action_data)
      @interface.display_product_removal(AdminService.fetch_product_data(action_data[:name]))

    when Actions::Admin::ADD_DENOMINATION_QUANTITY
      AdminService.add_change!(action_data)
      @interface.display_denomination_addition(action_data)

    when Actions::Admin::DECREASE_DENOMINATION_QUANTITY
      AdminService.remove_change!(action_data)
      @interface.display_denomination_removal(action_data)

    when Actions::Admin::DISPLAY_PRODUCTS
      @interface.display_data(AdminService.display_inventory)

    when Actions::Admin::DISPLAY_CASH_REGISTER
      @interface.display_data(AdminService.cash_register)
    end
  end

end