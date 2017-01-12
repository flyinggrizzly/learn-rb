class TeamProfile < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanHaveContact
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :subsets, dependent: :destroy
  has_many :team_memberships, dependent: :destroy
  has_many :person_profiles, through: :team_memberships
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true
  accepts_nested_attributes_for :subsets, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :team_memberships, allow_destroy: true, reject_if: :reject_team_memberships

  # Validate presence
  validates :subtype, presence: true
  validates :duties, presence: true

  # Validate subtype values
  validates :subtype, inclusion: { in: %w(academic_team
                                          professional_service_team
                                          leadership_team
                                          statutory_body
                                          committee
                                          working_group) }

  # Validate presence and must be one of list
  validates :membership_type, inclusion: { in: %w(profiles subsets) }

  # Validate length
  validates :duties,
            length: { maximum: 1_000 }

  # Ensure there are person profiles if membership_type is profiles
  validates :team_memberships,
            association_count: { minimum: 1, message: :profiles_team_no_profiles },
            if: proc { |team| team.membership_type == 'profiles' }

  # Ensure there are subsets if membership_type is subsets
  validates :subsets,
            association_count: { minimum: 1, message: :subsets_team_no_subsets },
            if: proc { |team| team.membership_type == 'subsets' }

  # Force the person profiles to be empty if membership_type is subsets
  validates :team_memberships,
            association_count: { maximum: 0, message: :subsets_team_no_profiles },
            if: proc { |team| team.membership_type == 'subsets' }

  # Force the subsets to be empty if membership_type is profiles
  validates :subsets,
            association_count: { maximum: 0, message: :profiles_team_no_subsets },
            if: proc { |team| team.membership_type == 'profiles' }

  # Reject team memberships
  def reject_team_memberships(attributes)
    # Will have an id if already exists
    exists = attributes['id'].present?
    # Consider invalid if no person_profile_id field
    empty = attributes['person_profile_id'].blank?
    # Add the destroy attribute if exists and is empty
    attributes[:_destroy] = 1 if exists && empty
    # Return for reject_if
    (!exists && empty)
  end

  def output_attributes
    output = attributes
    output[:team_members] = team_members_for_output unless person_profiles.blank?
    output[:subsets] = subsets(&:subset)
    output
  end

  private

  # Returns an array of hashes for redis to pass to publisher
  def team_members_for_output
    members = team_memberships.map do |tm|
      profile = tm.person_profile.published_version
      next unless profile.present?
      {
        title: profile.content_item.title,
        url_path: profile.content_item.url_path,
        role_holder_name: profile.role_holder_name,
        summary: profile.content_item.summary,
        role_holder_photo_url: profile.role_holder_photo_url,
        role_holder_photo_alt_text: profile.role_holder_photo_alt_text,
        role_holder_photo_caption: profile.role_holder_photo_caption,
        member_order: tm.member_order
      }
    end
    members.compact!

    # Split up the members who have or do not have an order for separate sorting later
    members_without_order = []
    members_with_order = []
    members.each do |member|
      if member[:member_order].nil?
        members_without_order << member
      else
        members_with_order << member
      end
    end

    # Sort the team members who have a specified order by order, then name
    members_with_order.sort_by! { |m| [m[:member_order], m[:role_holder_name]] }
    # Sort the team members who do not have a specified order by name only
    members_without_order.sort_by! { |m| m[:role_holder_name] }

    # List the ordered ones first, then ones without an order
    members_with_order + members_without_order
  end
end
