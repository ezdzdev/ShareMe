// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

$('#search-button').click(function() {
  $buttonDiv = $(this);
  $searchDiv = $('#search-text');
  $buttonDiv.prop('disabled', true);
  $buttonDiv.children().last().show();
  $buttonDiv.children().first().hide();
  $.post(
      '/search', {
        q: $searchDiv.val(),
        type: 'video'
      }, function(json) {
        console.log("HI");
        if (json.status == 'success') {
          console.log(json);
        } else if (json.status == 'error') {
          alert('Query error! ' + json.message);
        }
      }, 'application/json'
  ).fail(function() {
    alert('Server error!');
  }).always(function() {
    $buttonDiv.prop('disabled', false);
    $buttonDiv.children().last().hide();
    $buttonDiv.children().first().show();
  });
});