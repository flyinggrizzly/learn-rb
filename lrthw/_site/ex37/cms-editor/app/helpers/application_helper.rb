module ApplicationHelper
  # Generates a link to add a new field to a form
  # Puts the HTML for the field in a data- attribute on the link
  # * +name+        - text that goes in the link, e.g. 'Add URL'
  # * +f+           - the +FormBuilder+ object
  # * +association+ - pluralised name of the associated nested objects, e.g. :urls
  def link_to_add_fields(name, f, association)
    # Create a new, blank associated object
    new_object = f.object.class.reflect_on_association(association).klass.new
    # Generate the HTML for the new field from an association partial
    # Populate the index (id and name attributes) with a placeholder which will be replace by the JS
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize, f: builder)
    end
    # Create the link, passing in the html to a data- attribute and setting classes for display
    link_to name, 'javascript:void(0);', 'data-add-field' => html_escape("#{fields}"), class: 'button-secondary button-new', 'data-add-url' => 'true'
  end
end
