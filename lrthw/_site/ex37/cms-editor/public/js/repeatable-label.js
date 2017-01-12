$('#add-labels-info').ready(function() {
  // Get the content type from the hidden input field
  var contentType = $('#add-labels-info').next('input').attr('name').split('[')[0];

  // Get the non-JS multi-select box so we can manipulate it
  var labelsSelect = $('#' + contentType + '_content_item_attributes_label_ids');

  // Hide the non-JS multi-select box
  labelsSelect.hide();
  // Show the form elements we want for JavaScript based editing
  $('[data-js="show"]').css('display', 'block');

  // Get the existing labels (if there are any) and create new list items for them
  if (labelsSelect.find(':selected').length > 0) {
    $(labelsSelect.find(':selected').get().reverse()).each(function(index) {
      $('#add-to-content-item').after(repeatableFieldHTML(this.text, this.value, contentType));
    });
  }

  // Remove the non-JS multi-select box
  labelsSelect.remove();

  // Check if the "Add label" button should be disabled
  disableLabelSelection();

  // Add click event to Remove buttons which removes the input box
  addClickEventToRemoveButtons();

  // Add click event to 'Add label' button which creates a new repeatable field and removes the option from the select box
  $('[data-button="add-label"]').on('click', function(e) {
    e.preventDefault();
    $('#dummy_labels :selected').each(function() {
      if (this.value !== '' && $('#set-labels').children('.repeatable-field-medium').length < 8) {
        $('#add-to-content-item').after(repeatableFieldHTML(this.text, this.value, contentType));
        this.remove();
        addClickEventToRemoveButtons();
        disableLabelSelection();
      }
    });
    // Focus on the select box and reset it to the prompt
    $('#dummy_labels').val($('#dummy_labels option:first').val()).focus();
  });


  // Add a click event to all the remove buttons that removes the repeatable field and re-populates the select box
  function addClickEventToRemoveButtons() {
    $('[data-button="remove-label"]').unbind().on('click', function(e) {
      e.preventDefault();

      // Get the parts of the DOM that we need to manipulate
      var dummySelect = $('#dummy_labels');
      var dummyOptions = dummySelect.children();
      var dummyPrompt = dummyOptions.first();

      // Construct replacement html
      var siblings = $(this).siblings('input');
      var html = '<option value="' + siblings[1].value + '">' + siblings[0].value + '</option>';

      // Add an option for the one we're removing and remove the prompt for reordering
      dummyOptions = dummyOptions.add(html).remove(':first');

      // Sort the list alphabetically
      dummyOptions.sort(function(a, b) {
        if (a.text > b.text) return 1;
        else if (a.text < b.text) return -1;
        else return 0;
      });
      // Construct the select box again from the ordered list and prompt, and reset to prompt
      dummySelect.empty().append(dummyOptions).prepend(dummyPrompt).val(dummyPrompt.val());

      // Remove this whole .repeatable-field span
      $(this).parentsUntil('fieldset').remove();

      // Allow the user to add more labels if the number drops back to under 8
      enableLabelSelection();
    });
  }

  // Disable the "Add label" button when the limit of 8 labels is reached. Add a message to the user on what to do.
  function disableLabelSelection() {
    if ($('#set-labels').children('.repeatable-field-medium').length == 8) {
      var addLabelButton = $('[data-button="add-label"]');
      addLabelButton.addClass('disabled');
      addLabelButton.after('<span id="too-many-labels" class="disabled-button-message">Remove a label to add another.</span>');
    }
  }

  // Re-enable the "Add label" button when there are less than 8 labels. Remove instruction message.
  function enableLabelSelection() {
    if ($('#set-labels').children('.repeatable-field-medium').length < 8) {
      $('#too-many-labels').remove();
      $('[data-button="add-label"]').removeClass('disabled');
    }
  }

  // Provide HTML for the repeatable field with input box and remove button
  function repeatableFieldHTML(text, value, contentType) {
    return '<span class="repeatable-field-medium">' +
              '<input type="text" name="dummy_field" value="' + text + '" disabled/>' +
              '<input type="hidden" name="' + contentType + '[content_item_attributes][label_ids][]" value="' + value + '">' +
              '<a class="button-secondary button-inline negative" href="#" data-button="remove-label">Remove</a>' +
            '</span>';
  }
});
