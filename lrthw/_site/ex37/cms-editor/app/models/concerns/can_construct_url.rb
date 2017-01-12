require 'filepath_service'

# URL url_path uniqueness validation
# The validation is in the content types (eg PersonProfile) rather than ContentItem because we need to access
# content type fields and we can't do that in the ContentItem with the ContentItem nested in the content type
# forms (specifically for new items) eg we need role_holder_name to generate the url_path for PersonProfiles
#
# Construction methods refactored to lib/filepath_service.rb
module CanConstructUrl
  extend ActiveSupport::Concern

  included do
    # Validate unique URL
    validate :url_must_be_unique

    # Save url_path to content item
    before_save :populate_url_path
  end

  def url_must_be_unique
    # Check that the url_path doesn't already exist in the database (excluding the current item)
    url_path = FilepathService.generate_url_path(self)
    return if ContentItem.where(url_path: url_path).where.not(core_data_id: id).count == 0
    # Return slightly different error messages for person profiles because the url is constructed differently
    message = "The '" + I18n.t("#{self.class.name.underscore.pluralize}.title") + "' " + I18n.t('.url_must_be_unique')
    message = I18n.t('.url_must_be_unique_person') if self.class.name == 'PersonProfile'
    errors.add('content_item.title', message)
  end

  def populate_url_path
    content_item.url_path = FilepathService.generate_url_path(self)
  end
end
