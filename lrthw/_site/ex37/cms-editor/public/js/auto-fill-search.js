$(function() {
  $("#items").autocomplete({
    source: "/",
    minLength: 2,
    select: function(event, ui) {
      window.location.href=ui.item.url;
    }
  });
});
