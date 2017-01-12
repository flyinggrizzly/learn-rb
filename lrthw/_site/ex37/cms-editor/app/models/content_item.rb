require 'redis_service'

# Generic class for Content Items
class ContentItem < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanBeFiltered
  include CanSendToPublishingQueue
  include CanDisplayStatus
  include CanGetPinnableContentItems

  belongs_to :core_data, polymorphic: true
  belongs_to :organisation, inverse_of: :content_items
  has_many :collection_sections, through: :section_items
  has_many :section_items
  has_and_belongs_to_many :associated_orgs, class_name: 'Organisation', inverse_of: :associated_org_content_items,
                                            join_table: 'associated_orgs_content_items'
  has_and_belongs_to_many :labels
  has_paper_trail
  has_context_index

  # Validate presence
  validates :as_a, :i_need, :so_that, :title, :summary, :organisation, presence: true

  # Validate length
  validates :title,
            length: { maximum: 100 }
  validates :as_a, :i_need, :so_that,
            length: { maximum: 100 }
  validates :summary,
            length: { maximum: 160 }

  # Ensure there are no more than 8 labels
  validates :labels,
            length: { maximum: 8, message: :labels_too_many }
  # Ensure that for a Collection we have at least one Label
  validates :labels,
            length: { minimum: 1, message: :labels_too_few },
            if: :type_is_collection?

  # Ensure that Collection has unique set of labels
  validate :labels_must_be_unique, if: :type_is_collection?

  attr_accessor :republishing

  after_validation :check_last_published_url_path, if: 'published?'

  enum status: { draft: 0, in_review: 1, rejected: 2, published: 3, pending_publication: 4 }

  # Get the user who last modified or created this item
  def last_modified_by
    if updated_by.nil?
      created_by
    else
      updated_by
    end
  end

  # Public method to trigger a republish of this content item
  # See https://wiki.bath.ac.uk/display/webservices/Republishing+content+in+the+Content+Publisher
  def republish
    # This variable is needed to avoid triggering a double publish when republishing
    @republishing = true
    add_to_publisher_queue(publish_message('republish'))
  end

  private

  # Get the title, type and status for use in form select boxes
  def display_title_type_status
    type = core_data_type.underscore.humanize
    "#{title} (#{type}) - #{status.humanize}"
  end

  # Get the url_path of the last published version if it exists
  def check_last_published_url_path
    return if core_data_id.blank?
    # Get the associated object from the database rather than going via core_data because
    # accessing that breaks the data sent to the publisher
    last_published_version = core_data_type.constantize.find(core_data_id).published_version
    @last_published_url_path = last_published_version.content_item.url_path unless last_published_version.blank?
  end

  ## Validation methods

  # Used in label validation which is different for the Collection content type
  def type_is_collection?
    core_data_type == 'Collection'
  end

  # We should not be creating a Collection with the same labels as set on another Collection that already exists
  def labels_must_be_unique
    return true if labels.empty?

    label_names = labels.to_a.map(&:name).sort.join(' ')

    # TODO: we should revisit this for a more efficient solution https://www.pivotaltracker.com/n/projects/1262572/stories/127258403
    collection_items = ContentItem.where(core_data_type: 'Collection')

    collection_items.each do |col|
      # Make sure we don't test against the same object
      next if col.id == id
      col_labels = col.labels.to_a.map(&:name).sort.join(' ')

      if label_names == col_labels
        errors.add(:labels, :labels_not_unique)
        return false
      end
    end

    true
  end
end
