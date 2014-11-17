class Track < ActiveRecord::Base

  validates :track_vid, :uniqueness => true
  has_many :playlist_tracks, :dependent => :destroy
  has_many :playlists, :through => :playlist_tracks

  class << self
    def find_or_create_track( vid )
      track = Track.where(:track_vid => vid).first
      if track.blank?
        track = Track.new(:track_vid => vid)
        track.save!
      end

      track
    end
  end
end
