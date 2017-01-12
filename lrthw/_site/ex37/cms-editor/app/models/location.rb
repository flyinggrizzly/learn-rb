class Location < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanHaveContact
  include CanHaveFeaturedImage
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true

  # Validate presence
  validates :subtype, :map_embed_code, presence: true

  # Validate presence and must be one of list
  validates :subtype, inclusion: { in: %w(campus area building venue) }
  validates :on_off_campus, inclusion: { in: %w(on_campus off_campus),
                                         unless: proc { |location| location.subtype == 'campus' } }

  # Validate length
  validates :postcode,
            length: { maximum: 10 }
  validates :opening_time_monday, :opening_time_tuesday, :opening_time_wednesday, :opening_time_thursday,
            :opening_time_friday, :opening_time_saturday, :opening_time_sunday,
            length: { maximum: 25 }
  validates :building, :room, :address_1, :address_2, :town, :country, :latitude, :longitude,
            length: { maximum: 65 }
  validates :opening_time_notes,
            length: { maximum: 255 }
  validates :accessibility, :additional_information, :map_embed_code,
            length: { maximum: 1_000 }

  # Ensure there is a building/area if on campus
  validates :building,
            presence: { if: proc { |location| location.on_off_campus == 'on_campus' && location.subtype != 'campus' },
                        message: :on_campus_required }

  # Ensure there is address_1, town, postcode and country if off campus
  validates :address_1, :town, :postcode, :country,
            presence: { if: proc { |location| location.on_off_campus == 'off_campus' && location.subtype != 'campus' },
                        message: :off_campus_required }

  # Force the off campus fields to be empty if event is on campus
  validates :address_1, :address_2, :town, :country, :postcode,
            absence: { if: proc { |location| location.on_off_campus == 'on_campus' && location.subtype != 'campus' },
                       message: :off_campus_blank }

  # Force the on campus fields to be empty if event is off campus
  validates :building, :room,
            absence: { if: proc { |location| location.on_off_campus == 'off_campus' && location.subtype != 'campus' },
                       message: :on_campus_blank }

  # Ensure there is a longitude if there is a latitude and vice versa
  validates :longitude, presence: { if: :latitude? }
  validates :latitude, presence: { if: :longitude? }

  # Ensure that the latitude and longitude are valid numbers
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, allow_blank: true }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, allow_blank: true }

  def output_attributes
    attributes
  end
end
