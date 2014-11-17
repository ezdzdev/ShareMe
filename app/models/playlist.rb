class Playlist < ActiveRecord::Base
  # Schema Playlist
  # t.string   "user_hash"
  # t.string   "share_hash"
  # t.integer  "views"
  # t.integer  "responses"
  # t.datetime "created_at"
  # t.datetime "updated_at"
  validates_uniqueness_of :user_hash, :share_hash, :if => :saved?

  has_many :playlist_tracks,            :dependent => :destroy
  has_many :tracks,                     :through => :playlist_tracks

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
