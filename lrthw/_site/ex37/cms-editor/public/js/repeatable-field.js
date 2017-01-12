$('[data-controller="person_profiles"]').ready(function() {
  // Remove blank fields at bottom (used in no-js implementation) unless on validation error page
  if ($('body').data('action') != 'update') {
    $('.repeatable-field').slice(-3).remove();
  }

  // Remove checkboxes and labels (used in no-js implementation)
  $('.repeatable-field .no-js').remove();

  // Show add field button, remove field button and current fields heading
  $('.add-field, .remove-field, .current-fields').show();

  // Add event handler to remove field button
  $('.button-secondary.button-inline.negative').on('click', function(e){
    e.preventDefault();
    $(this).prev().val(true);
    $(this).parentsUntil('fieldset').fadeOut();
  });

  // Add event handler to add field button
  $('[data-add-url="true"]').on('click', function(e){
    e.preventDefault();
    var new_id = new Date().getTime();
    $(this).after($(this).data('add-field').replace(/new_[a-z]+/g, new_id));
    $(this).next().children('input').focus();
  });
});