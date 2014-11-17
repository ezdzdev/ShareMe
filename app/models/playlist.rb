class Playlist < ActiveRecord::Base
  has_many :playlist_tracks,            :dependent => :destroy
  has_many :tracks,                     :through => :playlist_tracks

  validates_uniqueness_of :user_hash, :share_hash, :if => :saved?

  def saved?
    self.saved
  end

  class << self
    def build_playlist
      hashid = Hashids.new("http://ezdz.io")
      playlist = Playlist.create!
      puts "okay"
      playlist.user_hash = hashid.encode(playlist.id,0)
      playlist.share_hash = hashid.encode(0,playlist.id)
      puts "no"
      playlist.saved = true
      playlist.save!

      playlist
    end
  end
end
