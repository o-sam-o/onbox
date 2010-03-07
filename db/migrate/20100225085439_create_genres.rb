class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table :genres do |t|
      t.string :name

      t.timestamps
    end

    create_table "genres_video_contents", :id => false do |t|
      t.column "video_content_id", :integer
      t.column "genre_id", :integer
    end
    add_index "genres_video_contents", "video_content_id"
    add_index "genres_video_contents", "genre_id"    
  end

  def self.down
    drop_table :genres
    drop_table :genres_video_contents
  end
end
