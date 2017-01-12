# Set and retrieve last published version via Papertrail, save last published version (as JSON) for Funnelback
module CanHavePublishingMetadataHooks
  extend ActiveSupport::Concern
  include CanFormatLabelsForFunnelback

  included do
    before_save :save_last_published_version_number, :save_published_version_for_funnelback
  end

  def save_last_published_version_number
    return unless content_item.published?
    # This is before save, so we want to reference the version about to be created
    new_version = versions.length + 1
    self.last_published_version = new_version
  end

  def published_version
    return self if content_item.published?
    return nil if last_published_version.blank?
    versions[last_published_version].reify(has_one: true, has_many: true)
  end

  def save_published_version_for_funnelback
    return unless content_item.published?
    published_item = content_item.attributes.except!('published_item_json')
    published_item[:core_data] = output_attributes
    # Format the labels for Funnelback Metadata
    published_item[:labels] = format_labels_for_funnelback(content_item.labels)

    content_item.published_item_json = published_item.to_json
  end
end
