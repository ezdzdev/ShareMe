// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery

$('#search-button').click(function() {
  console.log("HI");
  $button = $(this);
  $button.prop('disabled', true);
  $button.children().last().show();
  $button.children().first().hide();
});