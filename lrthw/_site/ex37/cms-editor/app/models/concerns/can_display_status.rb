# Every content type will go through different statuses as part of workflow.
module CanDisplayStatus
  extend ActiveSupport::Concern

  included do
    # Map new statuses onto buttons that are used to submit content item forms
    def self.status_message_map
      # These need to be strings because we call dasherize on them in action_message_for method
      {
        I18n.t('shared.status_buttons.save')           => 'draft',
        I18n.t('shared.status_buttons.save_close')     => 'draft',
        I18n.t('shared.status_buttons.revert')         => 'draft',
        I18n.t('shared.status_buttons.published_save') => 'draft',
        I18n.t('shared.status_buttons.finish')         => 'in_review',
        I18n.t('shared.status_buttons.publish')        => 'published'
      }
    end

    # Get the action that was taken based on the submit button text
    def self.action_map(action_text)
      case action_text
      when I18n.t('shared.status_buttons.save'), I18n.t('shared.status_buttons.published_save')
        action = :save
      when I18n.t('shared.status_buttons.save_close')
        action = :save_close
      when I18n.t('shared.status_buttons.finish')
        action = :finish
      when I18n.t('shared.status_buttons.publish')
        action = :publish
      when I18n.t('shared.status_buttons.revert')
        action = :revert
      end
      action
    end
  end
end
