require 'content_type_list_service'

class HighlightedItem < ActiveRecord::Base
  include CanStripCarriageReturns

  belongs_to :olp_announcement, class_name: 'OrganisationLandingPage'
  belongs_to :olp_campaign, class_name: 'OrganisationLandingPage'
  belongs_to :olp_case_study, class_name: 'OrganisationLandingPage'
  belongs_to :olp_corporate_information, class_name: 'OrganisationLandingPage'
  belongs_to :olp_event, class_name: 'OrganisationLandingPage'
  belongs_to :olp_guide, class_name: 'OrganisationLandingPage'
  belongs_to :olp_location, class_name: 'OrganisationLandingPage'
  belongs_to :olp_person_profile, class_name: 'OrganisationLandingPage'
  belongs_to :olp_project, class_name: 'OrganisationLandingPage'
  belongs_to :olp_publication, class_name: 'OrganisationLandingPage'
  belongs_to :olp_service_start, class_name: 'OrganisationLandingPage'
  belongs_to :olp_team_profile, class_name: 'OrganisationLandingPage'
  has_paper_trail

  validates :item, :item_order,
            numericality: { only_integer: true }
  validates :item_type,
            inclusion: { in: ContentTypeListService.without_landing_pages }

  default_scope { order('item_order ASC') }
end
