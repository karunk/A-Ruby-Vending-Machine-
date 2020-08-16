class CashRegisterService
  class << self

    POUND = 'pound'.freeze
    PENCE = 'pence'.freeze

    def add_change!(denomination_type, quantity)
      denomination = Denomination.find_by_change_type(denomination_type)
      raise InvalidDenominationError if denomination.nil?

      denomination.with_lock do
        denomination.increment!(:quantity, quantity)
      end
    end

    def withdraw_change!(change_type, quantity)
      denomination = Denomination.find_by_change_type(change_type)
      raise InvalidDenominationError if denomination.nil?

      raise NotEnoughChange if denomination.quantity < quantity

      denomination.with_lock do
        denomination.decrement!(:quantity, quantity)
      end
    end

    def calculate_balance(cost, cash)
      raise InvalidInputError unless cash.is_a? Numeric

      raise InvalidInputError unless cost.is_a? Numeric

      raise InsufficientAmountError if cost > cash

      (cost - cash).round(2).abs()
    end

    def withdraw(money)
      denominations = compute_denominations_to_return(money)
      ActiveRecord::Base.transaction do
        denominations.each do |denom, val|
          withdraw_change!(denom, val)
        end
      end
    end

    def compute_denominations_to_return(money_decimal)
      money = Money.new(money_decimal)
      computed_pound_hash  = compute_pounds(money.pound)
      computed_pence_hash = compute_pence(money.pence)
      computed_hash = computed_pound_hash.dup
      computed_pence_hash.each do |k, v|
        computed_hash[k] ||= 0
        computed_hash[k] += v
      end
      computed_hash
    end

    private

    def compute_pounds(pounds)
      denominations_hash = filter_denominations(POUND)

      computed_hash = {}
      denominations_hash.each do |h|
        if h[:quantity] > 0 && pounds > 0
          quantity = [pounds / h[:value], h[:quantity]].min
          h[:quantity]-=quantity
          pounds -= (h[:value] * quantity)
          computed_hash[h[:change_type]] = quantity
        end
      end

      return computed_hash if pounds.zero?

      computed_hash.merge!(compute_pence(convert_to_pence(pounds)))
    end

    def compute_pence(pence)
      denominations_hash = filter_denominations(PENCE)

      computed_hash = {}
      denominations_hash.each do |h|
        if h[:quantity] > 0 && pence > 0
          quantity = [pence / (h[:value]*100).to_i, h[:quantity]].min
          h[:quantity]-=quantity
          pence -= ((h[:value]*100).to_i * quantity)
          computed_hash[h[:change_type]] = quantity
        end
      end

      raise NotEnoughChange unless pence.zero?

      computed_hash
    end

    def convert_to_pence(pound)
      pound * 100
    end

    def filter_denominations(type)
      denominations_hash = Denomination.all.as_json

      if type == POUND
        denominations_hash.collect! {|a| a if a[:value] >= 1}
      elsif type == PENCE
        denominations_hash.collect! {|a| a if a[:value] < 1}
      end

      denominations_hash.compact!
      denominations_hash.sort_by! {|a| -a[:value]}
    end

  end
end