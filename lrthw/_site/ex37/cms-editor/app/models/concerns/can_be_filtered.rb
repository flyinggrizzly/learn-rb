# All the scopes for ContentItem
module CanBeFiltered
  extend ActiveSupport::Concern

  included do
    # Return all content items of given type belonging to the given org which have been published at some point
    scope :published_content_items_of_type_with_owning_org, lambda { |content_type, org_id|
      joins("INNER JOIN #{content_type.underscore.pluralize}\
            ON content_items.core_data_id = #{content_type.underscore.pluralize}.id")
        .where(core_data_type: content_type, organisation: org_id)
        .where.not(content_type.underscore.pluralize.to_s => { last_published_version: nil })
    }

    # Return all content items of given type with the given label which have been published at some point
    scope :filter_published_by_label_and_type, lambda { |label, content_type|
      filter_published_by_label(label).where(core_data_type: content_type)
    }

    # Return all content items with the given label which have been published at some point
    scope :filter_published_by_label, lambda { |label|
      includes(:labels).where(labels: { id: [label.id] }).where.not(published_item_json: nil)
    }

    # Dashboard filter
    scope :filter_by_org, -> (org) { where organisation: org }

    # Organisation landing page featured items
    scope :filter_published_by_org, lambda { |org_id|
      where(organisation_id: org_id)
        .where.not(core_data_type: 'OrganisationLandingPage')
        .where.not(published_item_json: nil)
        .order(title: :asc)
    }

    # Get all published items associated with an organisation
    scope :associated_published_by_org, lambda { |org_id|
      joins(:associated_orgs)
        .where('organisations.id' => org_id)
        .where.not(published_item_json: nil)
    }

    # Organisation landing page highlighted items (not currently in use)
    scope :filter_published_by_org_type, lambda { |org_id, content_type|
      filter_published_by_org(org_id).where(core_data_type: content_type)
    }

    # Filter content items that have `term` in the :title
    scope :search_title_by, lambda { |term|
      # Allow alphabetical character of any character set \p{L} or numbers
      # See https://ruby-doc.org/core-2.0.0/Regexp.html#class-Regexp-label-Character+Properties
      term = "%#{term.gsub(/[^\p{L}\w]/, ' ')}%"
      contains(:title, term) # contains() is an oracle-enhanced method - see https://github.com/rsim/oracle-enhanced
    }
  end
end
