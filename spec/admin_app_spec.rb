RSpec.describe AdminApp do

  before(:each) do
    $prompt = TTY::Prompt.new
  end

  context 'Initialize' do
    it 'Initializes a new Admin Interface' do
      expect(Interface::Admin).to receive(:new)

      AdminApp.new
    end
  end

  context 'Run' do
    it 'Invokes get_user_action in Admin Interface' do
      admin_app = AdminApp.new

      expect_any_instance_of(Interface::Admin).to receive(:display_available_actions)

      admin_app.run!
    end

    it 'Invokes get_user_action_data in Admin Interface' do
      allow_any_instance_of(TTY::Prompt).to receive(:select).and_return('some-user-action')
      admin_app = AdminApp.new

      expect_any_instance_of(Interface::Admin).to receive(:get_user_action_data)

      admin_app.run!
    end
  end

end