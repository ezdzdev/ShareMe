class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :track_name, :null => false
      t.string :track_url, :null => false

      t.timestamps
    end
  end
end
