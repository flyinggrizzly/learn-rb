# validate as a phone number
class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # valid if contains only numbers, brackets, spaces or a plus symbol
    return if value =~ /\A[\+ \(\)0-9]+\z/
    record.errors.add(attribute, (options[:message] || :phone_format))
  end
end
