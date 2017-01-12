class Event < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanHaveContact
  include CanHaveFeaturedImage
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true

  # validate presence
  validates :subtype, :start, :end, :audience, :booking_method, presence: true

  # validate presence and must be one of list
  validates :location, inclusion: { in: %w(on_campus off_campus) }

  # validate length
  validates :postcode, :room_number,
            length: { maximum: 8 }
  validates :hashtag,
            length: { maximum: 139 }
  validates :venue, :address_1, :address_2, :building, :town, :country,
            :audience_detail, :booking_email, :booking_link,
            length: { maximum: 255 }
  validates :accessibility, :speaker_profile,
            length: { maximum: 1_000 }
  validates :description,
            length: { maximum: 6_000 }

  # Validate price as a number greater than 0 and less than 100,000 but allow blank
  validates :price, numericality: { greater_than: 0, less_than: 100_000, allow_nil: true }

  # validate as email if present
  validates :booking_email, email: true, allow_blank: true

  # validate as url if present
  validates :booking_link, url: true, allow_blank: true

  # ensure start date is before the end date
  validates :end, date: { after: :start }

  # ensure there is a venue if on campus and building is empty
  validates :venue, presence: { if: proc { |event| event.location == 'on_campus' && event.building.blank? } }

  # force the off campus fields to be empty if event is on campus
  validates :address_1, :address_2, :town, :country, :postcode, absence: { if: proc { |event| event.location == 'on_campus' }, message: :off_campus_blank }

  # force the on campus fields to be empty if event is off campus
  validates :venue, :room_number, :building, absence: { if: proc { |event| event.location == 'off_campus'}, message: :on_campus_blank }

  # ensure there is a building if on campus and venue is empty or room_number is specified
  validates :building, presence: { if: proc { |event| event.location == 'on_campus' && (event.venue.blank? || !event.room_number.blank?) } }

  # ensure there are some address fields if event is off campus
  validates :address_1, :town, presence: { if: proc { |event| event.location == 'off_campus' }, message: :off_campus_required }

  # ensure there is an email if the booking method is an email
  validates :booking_email, presence: { if: proc { |event| event.booking_method == 'email' } }

  # ensure there is a link if the booking method is via an external site
  validates :booking_link, presence: { if: proc { |event| ['booking application', 'website'].include?(event.booking_method) } }

  # ensure there is a price if there is a charge
  validates :price, presence: { if: :charge? }

  def output_attributes
    attributes
  end
end
