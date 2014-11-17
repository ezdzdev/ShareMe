class AddSavedColumnToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :saved, :boolean, :default => false
  end
end
