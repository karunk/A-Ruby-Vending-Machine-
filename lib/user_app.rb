class UserApp < VendingMachineApp

  include Actions::User

  def initialize
    @interface = Interface::User.new
  end

  def run!
    @interface.display_data(UserService.display_inventory)
    begin
      @interface.get_user_action
      @interface.get_user_action_data
      perform!(@interface.selected_action, @interface.action_data)
    rescue => e
      handle_exceptions(e)
    end
    rerun!
  end

  private

  def perform!(action, action_data)
    case action
    when Actions::User::PLACE_ORDER
      receipt = UserService.place_order!(action_data)
      @interface.display_receipt(receipt.as_json)
    end
  end

end