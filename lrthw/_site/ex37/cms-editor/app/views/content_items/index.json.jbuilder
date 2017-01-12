json.array!(@content_items) do |content_item|
  json.label "#{content_item.title} - #{content_item.core_data_type.underscore.humanize}"
  json.url edit_polymorphic_path(content_item.core_data)
end
