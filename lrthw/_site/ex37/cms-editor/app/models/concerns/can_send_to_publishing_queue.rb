# All the publishing methods for ContentItem
module CanSendToPublishingQueue
  extend ActiveSupport::Concern
  include CanFormatLabelsForFunnelback

  included do
    after_commit { add_messages_to_publisher_queue unless @republishing }
    before_destroy :add_delete_message_to_publisher_queue
  end

  private

  def add_messages_to_publisher_queue
    # Don't publish ExternalItems
    return if core_data_type == 'ExternalItem'

    # Always publish to preview
    add_to_publisher_queue(publish_message('publish', 'preview'), 'preview')

    # Send a publish message to the publisher if we are in the published state and item not destroyed
    return unless published? && !destroyed?
    Rails.logger.info { "[Redis] Sending instruction to publish a content item. ID: #{id} Title: #{title}" }
    add_to_publisher_queue(publish_message)

    # Publish items which need updating due to the current item being published
    published_associated_items
  end

  def published_associated_items
    if core_data_type == 'PersonProfile'
      core_data.team_profiles.each do |tp|
        tp.content_item.republish
      end
    end
  end

  def add_delete_message_to_publisher_queue
    # Don't try to delete non-existent ExternalItems
    return if core_data_type == 'ExternalItem'

    Rails.logger.info { "[Redis] Sending instruction to delete a content item. ID: #{id} Title: #{title}" }
    add_to_publisher_queue(delete_message)
  end

  # Create JSON message to delete an item in the publisher app
  def delete_message(site = 'live')
    Rails.logger.debug { "[Redis] Sending message to delete a #{site} item. ID: #{id} Title: #{title}" }
    url_path_to_delete = if previous_changes['url_path'] && site == 'preview'
                           previous_changes['url_path'][0]
                         else
                           url_path
                         end
    { action: 'delete', site: site, path_to_delete: url_path_to_delete }.to_json
  end

  def add_to_publisher_queue(message, site = 'live')
    # Connect to redis
    redis = RedisService.connection

    # Send JSON message to redis for the publisher app
    Rails.logger.debug { "[Redis] Message: #{message}" }
    redis.publish(RedisService.channel(site), message)
  rescue
    # TODO: improve error handling and alerting
    Rails.logger.info { "[Redis] Could not send message to Redis. ID: #{id} Title: #{title}" }
    errors.add(:publish_queue, 'unavailable')
  end

  # Create JSON message to trigger a publish action in the publisher app
  def publish_message(type = 'publish', site = 'live')
    # Get the data for the message and include labels
    content_item, parent = type == 'republish' ? data_for_republish : data_for_publish

    # Get the organisation and landing_page_url
    organisation = Organisation.find(content_item['organisation_id'])
    landing_page_url = OrganisationLandingPage.landing_page_url_for_org(organisation) unless core_data_type ==
                                                                                             'OrganisationLandingPage'

    # Set the action and construct the JSON
    Rails.logger.info { "[Redis] Sending instruction to #{type} a #{site} content item. ID: #{id} Title: #{title}" }

    {
      action: 'publish',
      site: site,
      organisation: organisation.name,
      landing_page_url: landing_page_url,
      path_to_delete: path_to_delete
    }.merge(content_item).merge(parent).to_json

  rescue => error
    Rails.logger.debug { "[Redis] ERROR: #{error}" }
  end

  def data_for_republish
    # Get last published version of content_item and labels
    content_item = core_data.published_version.content_item.attributes.except!('published_item_json')
    content_item[:labels] = core_data.published_version.content_item.labels(&:label)
    # Get last published version of core_data
    parent = core_data.published_version.output_attributes

    # Update last_published_json so Funnelback gets changes to associated objects
    unless published_item_json.blank?
      # Format labels for Funnelback metadata
      funnelback_labels = format_labels_for_funnelback(content_item[:labels])
      self.published_item_json = content_item.merge(core_data: parent, labels: funnelback_labels).to_json
      # Custom method to work around an oracle bug. See config/initializers/update_record_without_timestamping.rb
      update_record_without_timestamping
    end
    [content_item, parent]
  end

  def data_for_publish
    # Get current version of content_item
    content_item = attributes.except!('published_item_json')
    content_item[:labels] = labels(&:label)
    # Get current version of core_data
    parent = core_data.output_attributes
    Rails.logger.debug { "[Redis] Previous changes: #{previous_changes.except!('published_item_json')}" }
    [content_item, parent]
  end

  def path_to_delete
    # previous_changes is an ActiveModel function: http://api.rubyonrails.org/classes/ActiveModel/Dirty.html#method-i-previous_changes
    if previous_changes['url_path'].present? && previous_changes['url_path'][0] != url_path
      # Delete the item at an old url if url_path changed in last save
      Rails.logger.debug { '[Redis] Including instruction to delete a content item based on previous_changes' }
      previous_changes['url_path'][0]
    elsif @last_published_url_path && @last_published_url_path != url_path
      # Delete the item at an old url if url_path changed since last publish
      Rails.logger.debug { '[Redis] Including instruction to delete a content item based on last_published_url_path' }
      @last_published_url_path
    else
      # No deletion necessary
      Rails.logger.debug { '[Redis] Not including path to delete' }
      nil
    end
  end
end