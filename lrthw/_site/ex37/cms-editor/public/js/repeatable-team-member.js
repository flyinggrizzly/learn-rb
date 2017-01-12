$('[data-controller="team_profiles"]').ready(function() {
  // Define HTML form elements that will be added with JavaScript
  // Replicate fields used for non-JavaScript implementation so new and existing members behave similarly
  var nonJsFields = function(membership_id, person_id, name) {
    return '<select aria-describedby="add-profiles-info" class="team-membership" name="team_profile[team_memberships_attributes[' + membership_id + ']person_profile_id]" id="team_profile_team_memberships_attributes_' + membership_id + '_person_profile_id" style="display: none;">' +
           '<option value="">No member</option>' + 
           '<option selected="selected" value="' + person_id + '">' + name + '</option>' + 
           '<input aria-described-by="add-profiles-info" size="3" class="member-order-field" type="text" name="team_profile[team_memberships_attributes][' + membership_id + '][member_order]" id="team_profile_team_memberships_attributes_' + membership_id + '_member_order" style="display: none;">';
  };

  // Visible repeatable field elements
  var visibleElements = function(name, status) {
    return '<span class="repeatable-field-medium">' +
             '<input type="text" name="dummy_field" value="' + name + '" disabled/>' +
             '<span class="item-status-' + status.toLowerCase() + ' status-indicator">' + status + '</span>' +
             '<a class="button-secondary button-inline negative" href="#" data-button="remove-profile">Remove</a>' +
           '</span>';
  };

  // Hidden field for destroying memberships
  var destroyField = function(membership_id) {
    return '<input type="hidden" name="team_profile[team_memberships_attributes][' + membership_id + '][_destroy]" id="team_profile_team_memberships_attributes_' + membership_id + '__destroy">';
  };

  // Remove the team-member divs for styling purposes
  $('.team-member select').unwrap();

  // Remove the microcopy for the non-JavaScript implementation
  $('p#add-profiles-info').remove();

  // Show the form elements we want for JavaScript based editing
  $('[data-js="show"]').css('display', 'block');
  $('[data-js="inline-block"]').css('display', 'inline-block');

  // Identify the list of team members and the dropdowns within
  var teamMembersList = $('#team-members-list');
  var teamMemberDropdowns = $('select.team-membership');

  // Check which dropdowns are in use and which are not
  var activeTeamMemberDropdowns = teamMemberDropdowns.filter(function (value) {
    return this.value;
  });
  var inactiveTeamMemberDropdowns = teamMemberDropdowns.filter(function (value) {
    return !this.value;
  });

  // Remove empty dropdowns (and related bits) in JavaScript implementation
  inactiveTeamMemberDropdowns.parentsUntil('ul').remove();

  // Move the statuses to data attributes
  $('#dummy_person_profiles option').each(function() {
    if (this.text != 'Select a team member') {
      var res = this.text.split(' - ');
      var name = res[0] + ' - ' + res[1];
      var status = res[2];

      this.text = name;
      $(this).attr('data-dummy-person-profiles-status', status);
    }
  });

  // Set up the existing members
  makeMembersSortable();
  styleExistingMembers();

  // Assign listeners for buttons to add and remove team members
  addClickEventToAddMembers();
  addClickEventToRemoveButtons();

  // Make the individual team members drag-and-drop sortable
  function makeMembersSortable() {
    teamMembersList.sortable({
      // Set the class for the placeholder list item that appears while something is being dragged
      placeholder: "repeatable-field-medium-placeholder",
      // Make the disabled inputs field draggable as well
      cancel: null,
      // After sorting, update the hidden 'member order' field based on this list item's index
      stop: function () {
        $('input.member-order-field').each(function(index) {
          $(this).val(index + 1);
        });
      }
    });
    teamMembersList.disableSelection();
  }

  // Hide non-JavaScript fields for existing members and style them up instead
  function styleExistingMembers() {
    activeTeamMemberDropdowns.find(':selected').each(function(index) {
      // Separate the status and the name and put each in its own box
      var memberId = $(this).parents('li').index();
      var res = this.text.split(' - ');
      var name = res[0] + ' - ' + res[1];
      var status = res[2];

      // Add visible dummy fields and hidden destroy field
      var html = visibleElements(name, status) + 
                 destroyField(memberId);
      $(this).parentsUntil('ul').last().append(html);

      // Hide the input fields and remove the labels
      teamMembersList.find('select').hide();
      teamMembersList.find('.member-order-field').hide();
      teamMembersList.find('label').remove();
    });
  }

  // Add new members from a single drop-down list
  function addClickEventToAddMembers() {
    $('[data-button="add-profile"]').on('click', function(e) {
      e.preventDefault();

      // Get member information from the drop-down list
      var currentOption = $('#dummy_person_profiles :selected');
      if (currentOption[0].value !== '') {
        var status =  $(currentOption).attr('data-dummy-person-profiles-status');

        // Get length of existing list to work out new ID
        newMemberId = teamMembersList.find('li').length;

        // Add (hidden) non-JS fields, dummy fields and hidden destroy field
        var html = '<li class="ui-sortable-handle">' + 
                     nonJsFields(newMemberId, currentOption[0].value, currentOption[0].text) + 
                     visibleElements(currentOption[0].text, status) + 
                     destroyField(newMemberId) +
                   '</li>';
        teamMembersList.append(html);

        // Check for remove buttons again so new members can be removed
        addClickEventToRemoveButtons();

        // Remove the member from the drop-down list
        currentOption.remove();
      }

      // Focus on the select box and reset it to the prompt
      $('#dummy_person_profiles').val($('#dummy_person_profiles option:first').val()).focus();
    });
  }

  // Delete memberships
  function addClickEventToRemoveButtons() {
    $('[data-button="remove-profile"]').unbind().on('click', function(e) {
      e.preventDefault();

      // Get the parts of the DOM that we need to manipulate
      var personProfilesSelect = $('#dummy_person_profiles');
      var personProfilesOptions = personProfilesSelect.children();
      var personProfilesPrompt = personProfilesOptions.first();

      // Get the status and construct replacement html
      var status = $(this).siblings('.status-indicator:first').text();
      var html = '<option value="' + $(this).parentsUntil('ul').siblings('.team-membership').val() + '" data-dummy-person-profiles-status="' + status + '">' + $(this).siblings('input').val() + '</option>';

      // Mark this membership for destruction and hide the visible elements
      $(this).parentsUntil('li').siblings().last().val('1');
      $(this).parentsUntil('ul').hide();

      // Add an option for the one we're removing and remove the prompt for reordering
      personProfilesOptions = personProfilesOptions.add(html).remove(':first');

      // Sort the list alphabetically
      personProfilesOptions.sort(function(a, b) {
        if (a.text > b.text) return 1;
        else if (a.text < b.text) return -1;
        else return 0;
      });

      // Construct the select box again from the ordered list and prompt, and reset to prompt
      personProfilesSelect.empty().append(personProfilesOptions).prepend(personProfilesPrompt).val(personProfilesPrompt.val());
    });
  }
});