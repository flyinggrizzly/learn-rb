# Validates a URL if it is not a page in the Content Publisher
class NonContentPublisherUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if validate_non_content_publisher_url(value)
    record.errors.add(attribute, (options[:message] || :non_content_publisher_url))
  end

  private

  def validate_non_content_publisher_url(value)
    url = URI.parse(value)
    # Check that the path doesn't match a content_item url_path
    return true if ContentItem.find_by_url_path(url.path.chomp('/')).blank?
  rescue URI::InvalidURIError
    false
  end
end
