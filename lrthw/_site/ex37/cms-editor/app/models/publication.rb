# Model for Publication content type
class Publication < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanHaveContact
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :publication_attachments, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true
  accepts_nested_attributes_for :publication_attachments, allow_destroy: true, reject_if: :all_blank

  # Validates presence
  validates :subtype, presence: true
  validates :publication_attachments, presence: true

  # Validate subtype values
  validates :subtype, inclusion: { in: %w(correspondence
                                          data
                                          form
                                          handbook
                                          manual
                                          minutes
                                          policy
                                          programme_specification
                                          promotional_material
                                          report) }

  # Validate length
  validates :additional_info,
            length: { maximum: 1_000 }
  validates :publication_attachments,
            length: { minimum: 1 }

  # Validates boolean present
  validates :restricted, inclusion: { in: [true, false] }

  def output_attributes
    output = attributes

    attachments_array = publication_attachments.map do |pa|
      attachment = {}
      attachment[:attachment_filename] = pa.attachment_filename
      attachment[:attachment_file_size] = pa.attachment.size
      attachment[:attachment_updated_at] = pa.updated_at
      attachment[:attachment_location] = pa.attachment.path
      attachment
    end

    # Convert the array into a hash for legitimate JSON
    output[:attachments] = Hash[attachments_array.each_with_index.map { |value, index| [index, value] }]

    output
  end
end
