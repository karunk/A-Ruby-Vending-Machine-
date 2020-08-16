class Denomination < ActiveRecord::Base

  PENCE_REGEX = /p$/
  POUND_REGEX = /^£/

  def as_json
    {
        'value': value,
        'change_type': change_type,
        'quantity': quantity
    }
  end

  def value
    if PENCE_REGEX.match?(change_type)
      (change_type[0..-2].to_f/100.0).round(2)
    elsif POUND_REGEX.match?(change_type)
      change_type[1..change_type.length].to_i
    end
  end

end