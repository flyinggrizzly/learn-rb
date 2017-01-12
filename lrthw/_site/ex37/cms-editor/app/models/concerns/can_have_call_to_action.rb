# Validations for call to action fields
module CanHaveCallToAction
  extend ActiveSupport::Concern

  included do
    # General lengths
    validates :call_to_action_label,
              length: { maximum: 65 }
    validates :call_to_action_content, :call_to_action_reason,
              length: { maximum: 255 }

    # Type present and in list
    validates :call_to_action_type, inclusion: { in: %w(url email phone none) }

    # Label and content required unless type is "none"
    validates :call_to_action_label, :call_to_action_content,
              presence: { unless: proc { |item| item.call_to_action_type == 'none' } }

    # Reason required if type is "none"
    validates :call_to_action_reason, presence: { if: proc { |item| item.call_to_action_type == 'none' } }

    # Content must be url if type is "url"
    validates :call_to_action_content, url: { if: proc { |item| item.call_to_action_type == 'url' } }

    # Content must be email if type is "email"
    validates :call_to_action_content, email: { if: proc { |item| item.call_to_action_type == 'email' } }

    # Content must be phone number if type is "phone"
    validates :call_to_action_content, phone: { if: proc { |item| item.call_to_action_type == 'phone' } }
  end
end
