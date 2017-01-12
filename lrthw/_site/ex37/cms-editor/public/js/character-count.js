// Show character counts in realtime
$(function() {
  $("[data-maxlength]").each(function () {
    // Get input element's id and maxlength
    var id = $(this).attr('id');
    var maxlength = $(this).data('maxlength');
    var warnlength = $(this).data('warnlength') ? $(this).data('warnlength') : maxlength;
    // Add the counter box above the input element
    $(this).before('<span id="' + id + '_counter" class="character-count"><strong id="' +
                    id + '_current"></strong> of <strong id="' + id + '_max">' +
                    maxlength + '</strong> characters used</span>');
    // Display initial count
    displayCharacterLimit(id, warnlength);

    // Assign event listener to input element for keypress, change or input event (should catch pasted in text)
    $(this).on('change keyup input', function() {
      displayCharacterLimit(id, warnlength);
    });
  });
});

// Sets the text and style for a field counter, given a field element id (or end of id) and the maximum length allowed
function displayCharacterLimit(elementId, warnLength) {
  // Set the current length
  var currentLength = $("[id$='" + elementId + "']").val().length;
  $("[id$='" + elementId + "_current']").text(currentLength);
  // Set the appropriate style
  if (currentLength > warnLength) {
    $("[id$='" + elementId + "_counter']").addClass('over-limit');
  } else {
    $("[id$='" + elementId + "_counter']").removeClass('over-limit');
  }
}
