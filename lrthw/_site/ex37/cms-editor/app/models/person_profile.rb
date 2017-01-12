class PersonProfile < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanHaveContact
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :urls, dependent: :destroy
  has_many :team_memberships, dependent: :destroy
  has_many :team_profiles, through: :team_memberships
  has_paper_trail

  accepts_nested_attributes_for :urls, allow_destroy: true, reject_if: ->(attributes) { attributes['url'].blank? }
  accepts_nested_attributes_for :content_item, allow_destroy: true

  # Validate presence
  validates :subtype, :role_holder_name, :supervisor_availability, presence: true

  # Validate length
  validates :role_holder_name, :role_holder_title,
            length: { maximum: 65 }
  validates :honours_post_nominal_letters, :person_finder_link,
            length: { maximum: 140 }
  validates :role_holder_photo_url, :role_holder_photo_alt_text, :role_holder_photo_caption, :all_publications_url,
            :subtype,
            length: { maximum: 255 }
  validates :achievements_in_role, :education, :research_interests, :current_research_projects,
            :role_related_posts_held, :courses_taught_undergrad, :courses_taught_postgrad,
            length: { maximum: 1_000 }
  validates :career_achievements,
            length: { maximum: 1_500 }

  # Validate as url if present
  validates :person_finder_link, :role_holder_photo_url, :all_publications_url, url: true, allow_blank: true

  enum supervisor_availability: { available: 0,
                                  unavailable: 1,
                                  proposals: 2,
                                  not_applicable: 3 }

  def output_attributes
    output = attributes
    if supervisor_availability.eql?('not_applicable')
      output.delete('supervisor_availability')
    else
      output['supervisor_availability'] =
        I18n.t("person_profiles.form.supervisor_availability_#{supervisor_availability}").downcase
    end
    output[:urls] = urls.map(&:url)
    output
  end

  def display_name_status
    status = I18n.t('publish_status.draft')
    status = I18n.t('publish_status.changed') unless published_version.blank?
    status = I18n.t('publish_status.published') if content_item.published?

    "#{role_holder_name} - #{content_item.title} - #{status}"
  end
end
