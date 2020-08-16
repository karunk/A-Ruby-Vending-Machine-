require 'active_record'
require 'byebug'
require 'config'
require 'models/product'
require 'models/inventory'
require 'models/order'
require 'models/receipt'
require 'models/money'
require 'models/denomination'
require 'services/admin_service'
require 'services/inventory_service'
require 'services/user_service'
require 'services/order_service'
require 'services/cash_register_service'
require 'services/billing_service'
require 'actions/admin'
require 'actions/user'
require 'actions/base'
require 'vending_machine_app'
require 'tty-prompt'
require 'tty-table'
require 'interface/base'
require 'interface/user'
require 'interface/admin'
require 'user_app'
require 'admin_app'
require 'exceptions/invalid_input_error'
require 'exceptions/not_enough_change'
require 'exceptions/duplicate_product_error'
require 'exceptions/not_enough_product_available_error'
require 'exceptions/product_not_found_error'
require 'exceptions/invalid_denomination_error'
require 'exceptions/not_enough_change'
require 'exceptions/insufficient_amount_error'


class Main

  class << self

    def db_configuration
      db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
      YAML.load(File.read(db_configuration_file))
    end

    def prompt
      TTY::Prompt.new(interrupt: :exit)
    end

    def load_application_config
      config_file = File.join(File.expand_path('..', __FILE__), '..', 'config')
      Config.load_and_set_settings(Config.setting_files(config_file, 'development'))
    end

    def fill_denominations
      Settings.supported_denominations.split(',').each do |d|
        existing = Denomination.find_by_change_type(d)
        Denomination.create('change_type': d, 'quantity': 10) if existing.nil?
      end
    end

    def start(development: true)
      load_application_config
      ActiveRecord::Base.establish_connection(db_configuration['development'])
      fill_denominations
      $prompt = prompt
      VendingMachineApp.new.run if development
    end

  end

end