# All pinnable items for aggregate types like OrgLandingPage
module CanGetPinnableContentItems
  extend ActiveSupport::Concern

  included do
    # Get all items that can be pinned on a given organisation's landing page
    def self.all_pinnable_by_org(org)
      # Directly owned or associated with the org
      items = ContentItem.filter_published_by_org(org.id)
      items |= ContentItem.associated_published_by_org(org.id)

      # Owned or associated with any child groups
      org.groups.each do |group|
        items |= ContentItem.filter_published_by_org(group.id)
        items |= ContentItem.associated_published_by_org(group.id)
      end

      # Convert the ActiveRecord results object to an array and sort by title, ascending
      items.to_a.sort_by { |a| a.title.downcase }
    end

    # Get all items that have all these labels
    def self.all_pinnable_by_labels(labels)
      items = []
      labels.each do |label|
        if items.empty?
          items = ContentItem.filter_published_by_label(label)
        else
          # Intersection of current items and items associated with a label
          items &= ContentItem.filter_published_by_label(label)
        end
      end

      # Sort by title, ascending
      items.sort_by { |a| a.title.downcase }
    end
  end
end
