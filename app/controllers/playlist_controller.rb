class PlaylistController < ApplicationController
  def create
    message = ''
    status = 'success'

    if params[:url] == '/'
      playlist = Playlist.build_playlist
      vid = get_vid_from_url(params[:v_url])
      track = Track.find_or_create_track(vid)
      PlaylistTrack.new(
          :playlist_id => playlist.id,
          :track_id => track.id,
      ).save!
    else
      playlist = Playlist.where(:share_hash => params[:url].gsub('/','')).last
      num_of_tracks = playlist.tracks.count
      if num_of_tracks < 50
        vid = get_vid_from_url(params[:v_url])
        track = Track.find_or_create_track(vid)
        pt = PlaylistTrack.new(
            :playlist_id => playlist.id,
            :track_id => track.id,
            :track_number => num_of_tracks + 1
        )
        if pt.valid?
          pt.save!
        else
          status = 'error'
          message = 'The playlist already has this track!'
        end
      else
        status = 'error'
        message = 'This playlist is full!'
      end
    end

    render json: {
        :user_hash => playlist.user_hash,
        :share_hash => playlist.share_hash,
        :status => status,
        :message => message
    }
  end

  def show
    options = {}
    options[:display] = 'user'
    options[:track_count] = 50
    @playlist = Playlist.where(:user_hash => params[:hash]).last

    # Try share link
    if @playlist.blank?
      options[:display] = 'share'
      options[:track_count] = 1
      @playlist = Playlist.where(:share_hash => params[:hash]).last
    end

    # 404
    if @playlist.blank?
      raise ActionController::RoutingError.new('Not Found')
    end

    @tracks = @playlist.tracks.
        order('track_number ASC').
        first(options[:track_count])
    @rendered_tracks = @tracks.map do |t|
      oembed = render_embedded_from_vid(t.track_vid)
      if oembed.blank?
        t.destroy
        next
      else
        oembed
      end
    end

    render 'playlist/show',
        :locals => {:options => options}
  end
end
