class CreateBookmarks < ActiveRecord::Migration[8.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.text :url, null: false
      t.string :title
      t.text :description
      t.string :thumbnail_url
      t.string :metadata_status, default: 'pending', null: false
      t.text :metadata_error

      t.timestamps
    end

    add_index :bookmarks, [:user_id, :url], unique: true
    add_index :bookmarks, :created_at
  end
end
