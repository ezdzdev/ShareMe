class RenamePlaylistColumnsUserUrlAndShareUrl < ActiveRecord::Migration
  def change
    rename_column :playlists, :user_url, :user_hash
    rename_column :playlists, :share_url, :share_hash
  end
end
