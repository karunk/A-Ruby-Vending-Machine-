class VendingMachineApp

  include Actions::Base

  def initialize
    @interface = Interface::Base.new
  end

  def run
    case @interface.mode
    when ADMIN_MODE
      AdminApp.new.run!
    when USER_MODE
      UserApp.new.run!
    end
  end

  def handle_exceptions(error)
    case error
    when ActiveRecord::RecordInvalid
      $prompt.error('An error occured while saving data.')
      $prompt.error('Please try again..')
    when DuplicateProductError
      $prompt.error('This product name is already registered.')
      $prompt.error('Please try again..')
    when InsufficientAmountError
      $prompt.error('This is not enough money to place this order.')
      $prompt.error('Please try again..')
    when NotEnoughChange
      $prompt.error('We do not have enough change to execute this order.')
      $prompt.error('Please try again..')
    when NotEnoughProductAvailableError
      $prompt.error('We do not have enough stock to execute this order.')
      $prompt.error('Please try again..')
    when ProductNotFoundError
      $prompt.error('We do not have the product you requested')
      $prompt.error('Please try again..')
    when InvalidInputError
      $prompt.error('You have entered an invalid input.')
      $prompt.error('Please try again..')
    else
      raise error
    end

    rerun!
  end

  def rerun!
    @interface.keypress
    system('clear')
    run!
  end


end