// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
$errorMsg = [
  "Search something, I'm giving up on you",
  "I'll be the one if you want me to",
  "Anywhere, I would have followed you",
  "Search something, I'm giving up on you",
  "And I...",
  "Am feeling so small",
  "It was over my head",
  "I know nothing at all",
  "And I...",
  "Will stumble and fall",
  "I'm still learning to love",
  "Just starting to crawl",
  "Search something, I'm giving up on you",
  "Mmmm...",
  "I'm sorry that I couldn't get to you",
  "Oh, no...",
  "Anywhere I would have followed you",
  "Ohhh...",
  "Search something, I'm giving up on you",
  "And I...",
  "Will swallow my pride",
  "You're the one that I love",
  "And I'm saying goodbye",
  "Whoa oh oh...",
  "Search something, I'm giving up on you ",
  "Search something...",
  "Search something...",
  "Search something...",
  "I'll be the one if you want me to",
  "Whoa oh oh...",
  "Search something",
  "Search something",
  "Search something, I'm giving up on you",
  "I'll be the one if you want me to",
  "Search something, I'm giving up on you",
  "I'll be the one if you want me to",
  "Say, Search something, I'm giving up on you ",
  "(Search something, I'm giving...)",
  "Oh whoa...",
  "(...up on you, whoa I'll...)",
  "I'll be the one if you want me to",
  "(...be the one if you...)",
  "Oh whoa...",
  "(...want me to, oh, Search something, I'm giving up on you)",
  "Search something, I'm giving up",
  "(whoa oh oh...)",
  "(I'll be the one if you want me to)",
  "If you want me to, oh, if you want me to",
  "(whoa oh oh)",
  "Anywhere, I would have followed you",
  "Whoa...",
  "Search something ",
  "(Search something)",
  "Search something",
  "(Search something)",
  "Search something",
  "(Search something)",
  "Ahh, ooh...",
  "Search something, I'm giving up on you",
  "Oh whoa..."
];
$errorNum = 0;

$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

$(document).keypress(function(e) {
  if(e.which == 13) {
    $('#search-button').trigger('click');
  }
});

$('#search-button').click(function() {
  $buttonDiv = $(this);
  $searchDiv = $('#search-text');
  if ($searchDiv.val() === '') {
    alert($errorMsg[$errorNum++]); // @DZ: known crash location
    return false;
  }
  $buttonDiv.prop('disabled', true);
  $buttonDiv.children().last().show();
  $buttonDiv.children().first().hide();
  $.post(
      '/search', {
        q: $searchDiv.val(),
        type: 'video',
        url: window.location.pathname
      }, function(json) {
        if (json.status == 'success') {
          renderResponse(json);
        } else if (json.status == 'error') {
          alert('Query error! ' + json.message);
        }
      }
  ).fail(function() {
    alert('Server error!');
  }).always(function() {
    // do nothing
  });
});

function create(caller) {
  $.post(
      '/playlist', {
        v_url: $(caller).siblings().attr('src'),
        url: window.location.pathname
      }, function(json) {
        if (json.status == 'success') {
          document.location.href = json.user_hash;
        } else if (json.status == 'error') {
          alert(json.message);
        }
      }
  ).fail(function() {
    alert('Server error!');
  }).always(function() {
    // do nothing
  });
}

function renderResponse( json ) {
  $resultsDiv = $('#results-container');
  $resultsDiv.empty();
  $.each(json.results, function( index, item ) {
    $container = createIframeContainer(item);
    $resultsDiv.append($container);
  });
  $resultsDiv.children().last().find('iframe').load(function () {
    $resultsDiv.children().each(function(i) {
      setTimeout(function() {
        if (i == 0) {
          $buttonDiv = $('#search-button');
          $buttonDiv.prop('disabled', false);
          $buttonDiv.children().last().hide();
          $buttonDiv.children().first().show();
        }
        $child = $($resultsDiv.children()[i]);
        $child.show();
        $child.addClass('animated fadeInDown')
      }, 1000*i);
    });
  });
}

function createIframeContainer( html ) {
  html = html.replace(/width=\"\d+(px)?\"/i, "width=\"480\"");
  html = html.replace(/height=\"\d+(px)?\"/i, "height=\"270\"");
  return [
    '<div class="search-iframe-container" style="display: none">',
    html,
    '<i class="fa fa-arrow-circle-right" onclick="create(this)"></i>',
    '</div>'
  ].join("\n");
}



