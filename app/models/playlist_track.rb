class PlaylistTrack < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :track

  validates_uniqueness_of :playlist, :scope => :track
end
