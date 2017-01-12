# For handling \n being converted by browser submission into \r\n and counting as 2 characters
module CanStripCarriageReturns
  extend ActiveSupport::Concern

  included do
    before_validation do
      attributes.each do |attr_name, value|
        write_attribute(attr_name, value.gsub(/\r\n/, "\n")) if value.is_a? String
      end
    end
  end
end
