RSpec.describe Interface::Admin do

  before(:each) do
    $prompt = TTY::Prompt.new
    @interface = Interface::Admin.new
  end

  context 'User Action' do

    it 'Displays list of actions in prompt' do
      expect_any_instance_of(TTY::Prompt).to receive(:select).with('What do you want to do? : ',
                                                                   ['Register new product',
                                                                    'Add product quantity',
                                                                    'Decrease product quantity',
                                                                    'Add Denomination Quantity',
                                                                    'Remove Denomination Quantity',
                                                                   'Display Products',
                                                                   'Display Cash Register'])

      @interface.display_available_actions
    end

    it 'Stores user selected action' do
      allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-user-action')

      @interface.display_available_actions

      expect(@interface.selected_action).to eq('some-user-action')
    end
  end

  context 'Fetches action data required' do
    context 'Action : Register new product' do
      it 'Sets action_data' do
        @interface.instance_variable_set(:@selected_action, Actions::Admin::NEW_PRODUCT_REG)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return('some-name', 100)

        @interface.get_user_action_data

        expect(@interface.action_data).to eq({ name: 'some-name',
                                               price: 100 })
      end
    end

    context 'Action : Add product quantity' do
      it 'Sets action_data' do
        @interface.instance_variable_set(:@selected_action, Actions::Admin::ADD_PRODUCT_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-product')
        allow(AdminService).to receive(:registered_products).and_return(%w(product-1 product-2))

        @interface.get_user_action_data

        expect(@interface.action_data).to eq({ name: 'some-product',
                                               quantity: 100 })
      end

      it 'Invokes Admin Service to fetch list of registered products' do
        @interface.instance_variable_set(:@selected_action, Actions::Admin::ADD_PRODUCT_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-product')

        expect(AdminService).to receive(:registered_products)

        @interface.get_user_action_data
      end

      it 'Displays list of registered products in prompt' do
        @interface.instance_variable_set(:@selected_action, Actions::Admin::ADD_PRODUCT_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-product')
        allow(AdminService).to receive(:registered_products).and_return(%w(product-1 product-2))

        expect_any_instance_of(TTY::Prompt).to receive(:select).with('Select product to modify :',
                                                                     %w(product-1 product-2), {})

        @interface.get_user_action_data
      end
    end

    context 'Action : Decrease product quantity' do
      it 'Sets action_data' do
        @interface.instance_variable_set(:@selected_action, Actions::Admin::DECREASE_PRODUCT_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-product')
        allow(AdminService).to receive(:registered_products).and_return(%w(product-1 product-2))

        @interface.get_user_action_data

        expect(@interface.action_data).to eq({ name: 'some-product',
                                               quantity: 100 })
      end

      it 'Invokes Admin Service to fetch list of registered products' do
        @interface.instance_variable_set(:@selected_action, Actions::Admin::DECREASE_PRODUCT_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-product')

        expect(AdminService).to receive(:registered_products)

        @interface.get_user_action_data
      end

      it 'Displays list of registered products in prompt' do
        @interface.instance_variable_set(:@selected_action, Actions::Admin::DECREASE_PRODUCT_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-product')
        allow(AdminService).to receive(:registered_products).and_return(%w(product-1 product-2))

        expect_any_instance_of(TTY::Prompt).to receive(:select).with('Select product to modify :',
                                                                     %w(product-1 product-2), {})

        @interface.get_user_action_data
      end
    end

    context 'Action : Add Denomination' do
      before(:each) do
        Config.load_and_set_settings(Config.setting_files('', 'development'))
      end

      it 'Sets action_data' do
        allow(Settings).to receive(:[]).and_return('1,2,3')
        @interface.instance_variable_set(:@selected_action, Actions::Admin::ADD_DENOMINATION_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-name')

        @interface.get_user_action_data

        expect(@interface.action_data).to eq({ change_type: 'some-name',
                                               quantity: 100 })
      end

      it 'Displays list of supported denominations in prompt' do
        allow(Settings).to receive(:[]).and_return('product-1,product-2')
        @interface.instance_variable_set(:@selected_action, Actions::Admin::ADD_DENOMINATION_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-name')

        expect_any_instance_of(TTY::Prompt).to receive(:select).with('Select denomination :',
                                                                     %w(product-1 product-2), {})

        @interface.get_user_action_data
      end
    end

    context 'Action : Remove Change' do
      before(:each) do
        Config.load_and_set_settings(Config.setting_files('', 'development'))
      end

      it 'Sets action_data' do
        allow(Settings).to receive(:[]).and_return('1,2,3')
        @interface.instance_variable_set(:@selected_action, Actions::Admin::DECREASE_DENOMINATION_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-name')

        @interface.get_user_action_data

        expect(@interface.action_data).to eq({ change_type: 'some-name',
                                               quantity: 100 })
      end

      it 'Displays list of supported denominations in prompt' do
        allow(Settings).to receive(:[]).and_return('product-1,product-2')
        @interface.instance_variable_set(:@selected_action, Actions::Admin::DECREASE_DENOMINATION_QUANTITY)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).and_return(100)
        allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-name')

        expect_any_instance_of(TTY::Prompt).to receive(:select).with('Select denomination :',
                                                                     %w(product-1 product-2), {})

        @interface.get_user_action_data
      end
    end
  end

end