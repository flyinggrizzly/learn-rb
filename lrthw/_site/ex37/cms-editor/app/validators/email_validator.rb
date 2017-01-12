# validate as an email
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # valid if contains an @ and doesn't end with a period
    return if value =~ /@/ && !value.end_with?('.')
    record.errors.add(attribute, (options[:message] || :email_format))
  end
end
