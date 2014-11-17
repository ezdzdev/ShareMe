class ChangePlaylistTrackColumnTrackNumber < ActiveRecord::Migration
  def change
    change_column :playlist_tracks, :track_number, :integer, :null => false
  end
end
