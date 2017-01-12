require 'filepath_service'
require 'content_type_list_service'

class OrganisationLandingPage < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanConstructUrl
  include CanHaveContact
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :highlighted_announcements, class_name: 'HighlightedItem', foreign_key: 'olp_announcement_id', dependent: :destroy
  has_many :highlighted_campaigns, class_name: 'HighlightedItem', foreign_key: 'olp_campaign_id', dependent: :destroy
  has_many :highlighted_case_studies, class_name: 'HighlightedItem', foreign_key: 'olp_case_study_id', dependent: :destroy
  has_many :highlighted_corporate_informations, class_name: 'HighlightedItem', foreign_key: 'olp_corporate_information_id', dependent: :destroy
  has_many :highlighted_events, class_name: 'HighlightedItem', foreign_key: 'olp_event_id', dependent: :destroy
  has_many :highlighted_guides, class_name: 'HighlightedItem', foreign_key: 'olp_guide_id', dependent: :destroy
  has_many :highlighted_locations, class_name: 'HighlightedItem', foreign_key: 'olp_location_id', dependent: :destroy
  has_many :highlighted_person_profiles, class_name: 'HighlightedItem', foreign_key: 'olp_person_profile_id', dependent: :destroy
  has_many :highlighted_projects, class_name: 'HighlightedItem', foreign_key: 'olp_project_id', dependent: :destroy
  has_many :highlighted_publications, class_name: 'HighlightedItem', foreign_key: 'olp_publication_id', dependent: :destroy
  has_many :highlighted_service_starts, class_name: 'HighlightedItem', foreign_key: 'olp_service_start_id', dependent: :destroy
  has_many :highlighted_team_profiles, class_name: 'HighlightedItem', foreign_key: 'olp_team_profile_id', dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true
  accepts_nested_attributes_for :highlighted_announcements, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_campaigns, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_case_studies, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_corporate_informations, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_events, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_guides, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_locations, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_person_profiles, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_projects, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_publications, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_service_starts, allow_destroy: true, reject_if: :reject_highlighted
  accepts_nested_attributes_for :highlighted_team_profiles, allow_destroy: true, reject_if: :reject_highlighted

  # Validate presence
  validates :about, :subtype,
            presence: true

  # Validate presence and must be one of list
  validates :on_off_campus, inclusion: { in: %w(on_campus off_campus) }
  validates :content_list,  inclusion: { in: %w(groups locations services teams) }

  # Validate length
  validates :postcode,
            length: { maximum: 10 }
  validates :building, :room, :address_1, :address_2, :town, :country,
            length: { maximum: 65 }
  validates :about,
            length: { maximum: 255 }

  # Ensure there is a building/area if on campus
  validates :building,
            presence: { if: proc { |location| location.on_off_campus == 'on_campus' },
                        message: :on_campus_required }

  # Ensure there is address_1, town, postcode and country if off campus
  validates :address_1, :town, :postcode, :country,
            presence: { if: proc { |location| location.on_off_campus == 'off_campus' },
                        message: :off_campus_required }

  # Force the off campus fields to be empty if event is on campus
  validates :address_1, :address_2, :town, :country, :postcode,
            absence: { if: proc { |location| location.on_off_campus == 'on_campus' },
                       message: :off_campus_blank }

  # Force the on campus fields to be empty if event is off campus
  validates :building, :room,
            absence: { if: proc { |location| location.on_off_campus == 'off_campus' },
                       message: :on_campus_blank }

  # Ensure we don't have more than 6 highlighted items per content type
  validates :highlighted_announcements, :highlighted_campaigns, :highlighted_case_studies,
            :highlighted_corporate_informations, :highlighted_events, :highlighted_guides,
            :highlighted_locations, :highlighted_person_profiles, :highlighted_projects,
            :highlighted_publications, :highlighted_service_starts, :highlighted_team_profiles,
            length: { maximum: 6 }

  scope :landing_pages_for_org, lambda { |org_id|
    joins('inner join content_items on content_items.core_data_id = organisation_landing_pages.id')
      .where('content_items.organisation_id = ?', org_id)
      .where("content_items.core_data_type = 'OrganisationLandingPage'")
  }

  def output_attributes
    output = attributes

    # Get the featured items
    output[:featured_item_1] = feature_item_output(featured_item_1) unless featured_item_1.blank?
    output[:featured_item_2] = feature_item_output(featured_item_2) unless featured_item_2.blank?
    output[:featured_item_3] = feature_item_output(featured_item_3) unless featured_item_3.blank?
    output[:featured_item_4] = feature_item_output(featured_item_4) unless featured_item_4.blank?
    output[:featured_item_5] = feature_item_output(featured_item_5) unless featured_item_5.blank?
    output[:featured_item_6] = feature_item_output(featured_item_6) unless featured_item_6.blank?

    ContentTypeListService.without_landing_pages.each do |type|
      if content_type?(type)
        output[type.underscore.pluralize.to_sym] = FilepathService.generate_path(type, subtype)
      end
    end

    # Get the items for the content list, default to groups
    if %w(locations services teams).include? output['content_list']
      # Set the content type
      content_type = 'Location' if output['content_list'] == 'locations'
      content_type = 'ServiceStart' if output['content_list'] == 'services'
      content_type = 'TeamProfile' if output['content_list'] == 'teams'
      # Get the content items
      items = ContentItem.published_content_items_of_type_with_owning_org(content_type, content_item.organisation.id)
      unless items.blank?
        output[:content_list_items] = []
        items.each do |item|
          output[:content_list_items] << { 'title' => item.title, 'url' => item.url_path }
        end
      end
    else
      # Set the content_list to groups, in case it's blank
      output['content_list'] = 'groups'
      # Get the groups and their corresponding landing page url
      unless content_item.organisation.groups.blank?
        output[:content_list_items] = []
        content_item.organisation.groups.each do |group|
          output[:content_list_items] << { 'title' => group.name, 'url' => self.class.landing_page_url_for_org(group) }
        end
      end
    end
    # Sort the content list alphabetically by title
    output[:content_list_items].sort_by! { |x| x['title'] } unless output[:content_list_items].blank?

    output
  end

  def feature_item_output(id)
    featured_item = ContentItem.find(id).core_data.published_version

    output = {}
    output[:title] = featured_item.content_item.title
    output[:summary] = featured_item.content_item.summary
    output[:content_type] = featured_item.content_item.core_data_type
    output[:subtype] = featured_item.subtype if featured_item.has_attribute?(:subtype)
    output[:url_path] = if output[:content_type] == 'ExternalItem'
                          featured_item.external_url
                        else
                          featured_item.content_item.url_path
                        end

    # Add featured image if the item has one
    if featured_item.has_attribute?(:featured_image) && featured_item.featured_image.present?
      output[:featured_image] = featured_item.featured_image
      output[:featured_image_alt] = featured_item.featured_image_alt
    end

    output
  end

  # Does this organisation have published content items of the given type?
  def content_type?(content_type)
    org_id = content_item.organisation.id
    published_item_count = ContentItem.published_content_items_of_type_with_owning_org(content_type, org_id).count
    published_item_count > 0
  end

  def reject_highlighted(attributes)
    # Will have an id if already exists
    exists = attributes['id'].present?
    # Consider invalid if no item field
    empty = attributes['item'].blank?
    # Add the destroy attribute if exists and is empty
    attributes.merge!(_destroy: 1) if exists && empty
    # Return for reject_if
    (!exists && empty)
  end

  def self.landing_page_url_for_org(org)
    lps = landing_pages_for_org(org.id)
    return nil if lps.blank? || lps.first.published_version.blank?
    lps.first.published_version.content_item.url_path
  end
end
