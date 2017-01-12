require 'filepath_service'
require 'content_type_list_service'

class Collection < ActiveRecord::Base
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :collection_sections, dependent: :destroy
  has_many :section_items, through: :collection_sections, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true
  accepts_nested_attributes_for :collection_sections, allow_destroy: true, reject_if: :reject_collection_sections
  accepts_nested_attributes_for :section_items, allow_destroy: true, reject_if: :all_blank

  def reject_collection_sections(attributes)
    # Will have an id if already exists
    exists = attributes['id'].present?
    # Consider invalid if no title and summary field
    empty = attributes['title'].blank? && attributes['summary'].blank?
    # Add the destroy attribute if exists and is empty
    attributes[:_destroy] = 1 if exists && empty
    # Return for reject_if
    (!exists && empty)
  end

  # Does this collection have published content items of the given type?
  def published_items?(content_type)
    items = []
    content_item.labels.each do |label|
      if items.empty?
        items = ContentItem.filter_published_by_label_and_type(label, content_type)
      else
        # Intersection of current items and items associated with a label
        items &= ContentItem.filter_published_by_label_and_type(label, content_type)
      end
    end
    items.count > 0
  end

  def section_item_output(id)
    section_item = ContentItem.find(id).core_data.published_version

    output = {}
    output[:title] = section_item.content_item.title
    output[:summary] = section_item.content_item.summary
    output[:content_type] = section_item.content_item.core_data_type
    output[:subtype] = section_item.subtype if section_item.has_attribute?(:subtype)
    output[:url_path] = if output[:content_type] == 'ExternalItem'
                          section_item.external_url
                        else
                          section_item.content_item.url_path
                        end

    # Add featured image if the item has one
    if section_item.has_attribute?(:featured_image) && section_item.featured_image.present?
      output[:featured_image] = section_item.featured_image
      output[:featured_image_alt] = section_item.featured_image_alt
    end

    output
  end

  def output_attributes
    output = attributes

    ContentTypeListService.without_landing_pages.each do |type|
      if published_items?(type)
        output[type.underscore.pluralize.to_sym] = FilepathService.generate_path(type, nil)
      end
    end

    output[:collection_sections] = collection_sections.map do |section|
      section_output = section.attributes
      section_output[:section_items] = section.content_items.map { |item| section_item_output(item.id) }
      section_output
    end

    output
  end
end
