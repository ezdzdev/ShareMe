class CreatePlaylistTracks < ActiveRecord::Migration
  def change
    create_table :playlist_tracks do |t|
      t.belongs_to :playlist
      t.belongs_to :track
      t.integer :track_number

      t.timestamps
    end
  end
end
