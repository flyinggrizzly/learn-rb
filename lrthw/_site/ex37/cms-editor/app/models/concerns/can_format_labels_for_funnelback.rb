# Set and retrieve last published version via Papertrail, save last published version (as JSON) for Funnelback
module CanFormatLabelsForFunnelback
  extend ActiveSupport::Concern

  def format_labels_for_funnelback(labels)
    # Format the labels for Funnelback Metadata
    labels.map(&:name).join('|').tr(' ', '_')
  end
end
