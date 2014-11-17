//= require jquery

$playlist = $('#playlist-container');
$('.playlist-iframe-container').each(function(i) {
  setTimeout(function() {
    $container = $($playlist.children()[i]);
    $container.show();
    $container.addClass('animated fadeInLeft');
  }, 1000*i);
});


