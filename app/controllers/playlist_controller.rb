class PlaylistController < ApplicationController
  def create
    playlist = Playlist.build_playlist
    vid = get_vid_from_url(params[:url])
    track = Track.find_or_create_track(vid)
    PlaylistTrack.new(
        :playlist_id => playlist.id,
        :track_id => track.id,
    ).save!

    render json: {
        :user_hash => playlist.user_hash,
        :share_hash => playlist.share_hash,
        :status => 'success',
        :message => 'this shouldn\'t happen'
    }
  end

  def show
    options = {}
    options[:display] = 'user'
    @playlist = Playlist.where(:user_hash => params[:hash]).last

    # Try share link
    if @playlist.blank?
      options[:display] = 'share'
      @playlist = Playlist.where(:share_hash => params[:hash]).last
    end

    # 404
    if @playlist.blank?
      raise ActionController::RoutingError.new('Not Found')
    end

    @tracks = @playlist.tracks.order('track_number ASC').all
    @rendered_tracks = @tracks.map{ |t| render_embedded_from_vid(t.track_vid) }
    render 'playlist/show', :locals => {:options => options}
  end
end
