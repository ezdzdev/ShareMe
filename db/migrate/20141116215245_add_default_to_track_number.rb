class AddDefaultToTrackNumber < ActiveRecord::Migration
  def change
    change_column :playlist_tracks, :track_number, :integer, :null => false ,:default => 1
  end
end
