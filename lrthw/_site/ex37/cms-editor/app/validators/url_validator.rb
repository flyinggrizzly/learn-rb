# Validates a URL if it is:
#  * any valid http:// or https:// URL
#  * a root relative path to a content item in the CMS
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if validate_url(value)
    record.errors.add(attribute, (options[:message] || :url_format))
  end

  private

  def validate_url(value)
    url = URI.parse(value)

    if url.scheme.nil?
      ContentItem.find_by_url_path(url.path.chomp('/'))
    else
      url.scheme.in?(%w(http https))
    end
  rescue URI::InvalidURIError
    false
  end
end
