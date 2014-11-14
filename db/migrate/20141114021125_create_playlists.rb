class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :user_url, :null => false
      t.string :share_url, :null => false
      t.integer :views
      t.integer :responses

      t.timestamps
    end
  end
end
