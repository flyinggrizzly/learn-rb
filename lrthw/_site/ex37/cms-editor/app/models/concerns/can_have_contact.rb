# standard validations for contact details fields
module CanHaveContact
  extend ActiveSupport::Concern

  included do
    validates :contact_name, :contact_email, :contact_phone, length: { maximum: 255 }

    # validate as phone number if present
    validates :contact_phone, phone: true, allow_blank: true

    # validate as email if present
    validates :contact_email, email: true, allow_blank: true
  end
end
