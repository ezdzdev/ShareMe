class RenameTrackColumnTrackUrl < ActiveRecord::Migration
  def change
    rename_column :tracks, :track_url, :track_vid
  end
end
