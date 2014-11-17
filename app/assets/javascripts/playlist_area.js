//= require jquery
$playlist = $('#playlist-container');
$('.playlist-iframe-container').each(function(i) {
  setTimeout(function() {
    $container = $($playlist.children()[i]);
    $container.show();
    $container.addClass('animated fadeInLeft');

  }, 1000*i);
});

$playlistVideos = [];
$playlistShuffleVideos = [];
$playlistCurrentArr = 0;
$playlistPlay = false;
$playlistRepeat = false;
$playlistShuffle = false;
/* Playlist controls */
$('#controls-backwards').click(function() {
  startPrevVideo($playlistCurrentArr);
});

$('#controls-play').click(function() {
  $playlistPlay = !$playlistPlay;
  $(this).toggleClass('fa-play');
  $(this).toggleClass('fa-pause');
  if ($playlistPlay) {
    $playlistCurrentArr[1].playVideo();
  } else {
    $playlistCurrentArr[1].pauseVideo();
  }
});

$('#controls-forwards').click(function() {
  startNextVideo($playlistCurrentArr);
});

$('#controls-shuffle').click(function() {
  $playlistShuffle = !$playlistShuffle;
  $(this).toggleClass('active');
  if ($playlistShuffle) {
    shuffleStartingAtCurrentVideo($playlistVideos);
  }
});

$('#controls-repeat').click(function() {
  $playlistRepeat = !$playlistRepeat;
  $(this).toggleClass('active');
});

function shuffleStartingAtCurrentVideo() {
  // Copy over video list and swap current with first
  $playlistShuffleVideos = $playlistVideos.splice();
  $first = $playlistShuffleVideos[0];
  $playlistShuffleVideos[0] = $playlistCurrentArr;
  $playlistShuffleVideos[$playlistCurrentArr[0]] = $first;


  // Loop through rest of array [length..1] to randomize
  var currentIndex = $playlistShuffleVideos.length, temporaryValue, randomIndex ;

  // While there remain elements to shuffle...
  while (1 !== currentIndex) {
    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = $playlistCurrentArr[currentIndex];
    $playlistCurrentArr[currentIndex] = $playlistCurrentArr[randomIndex];
    $playlistCurrentArr[randomIndex] = temporaryValue;
  }
}


/* YT Event listeners */
function onYouTubeIframeAPIReady() {
  $('.playlist-iframe-container>iframe').each(function(i) {
    $iframeYT = $(this);
    $iframeYT.addClass('jsYTListen');
    $iframeYT.attr('src',$iframeYT.attr('src') + '&enablejsapi=1');
    player = new YT.Player($iframeYT[0], {
      events: {
        'onStateChange': onPlayerStateChange
      }
    });
    $playlistVideos.push([i,player]);
  });
  $playlistCurrentArr = $playlistVideos[0];
}

function onPlayerStateChange(event) {
  if (event.data == YT.PlayerState.ENDED) {
    if ($playlistRepeat && !$playlistShuffle) {
      $playlistCurrentArr[1].playVideo();
    } else {
      startNextVideo($playlistCurrentArr);
    }
  } else if (event.data == YT.PlayerState.PAUSED) {
    if ($playlistPlay) {
      $('#controls-play').trigger('click');
    }
  } else if (event.data == YT.PlayerState.PLAYING) {
    $playlistCurrentArr = findCurrentPlayer(event.data);
    if (!$playlistPlay) {
      $('#controls-play').trigger('click');
    }
  }
}

function findCurrentPlayer(event) {
  $playerArr = [];
  $.each($playlistVideos, function(index, value) {
    if (value[1].getPlayerState() === event) {
      $playerArr = value;
      return false;
    }
  });
  return $playerArr;
}

function startPrevVideo(playerArr) {
  var currPlayer = playerArr[1];
  if (playerArr[1].getPlayerState() !== YT.PlayerState.ENDED) {
    currPlayer.pauseVideo();
  }

  // @DZ Add circular logic and prevent crash

  var prevPlayer = ($playlistShuffle) ?
      $playlistShuffleVideos[playerArr[0]-1][1] : $playlistVideos[playerArr[0]-1][1];
  prevPlayer.playVideo();
}

function startNextVideo(playerArr) {
  var currPlayer = playerArr[1];
  if (playerArr[1].getPlayerState() !== YT.PlayerState.ENDED) {
    currPlayer.pauseVideo();
  }

  // @DZ Add circular logic and prevent crash
  var nextPlayer = ($playlistShuffle) ?
      $playlistShuffleVideos[playerArr[0]+1][1] : $playlistVideos[playerArr[0]+1][1];
  nextPlayer.playVideo();
}

