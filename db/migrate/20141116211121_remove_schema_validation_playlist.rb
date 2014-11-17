class RemoveSchemaValidationPlaylist < ActiveRecord::Migration
  def change
    change_column_null :playlists, :user_hash, true
    change_column_null :playlists, :share_hash, true
  end
end
