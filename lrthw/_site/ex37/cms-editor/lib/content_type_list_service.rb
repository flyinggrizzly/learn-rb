# Access to lists of the content types
module ContentTypeListService
  def self.all
    %w(Announcement
       Campaign
       CaseStudy
       Collection
       CorporateInformation
       Event
       Guide
       Location
       OrganisationLandingPage
       PersonProfile
       Project
       Publication
       ServiceStart
       TeamProfile)
  end

  def self.without_landing_pages
    all - %w(Collection OrganisationLandingPage)
  end
end
