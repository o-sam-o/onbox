class CreateVideoPosters < ActiveRecord::Migration
  def self.up
    create_table :video_posters do |t|
      t.string :size
      t.string :location
      t.integer :height
      t.integer :width
      t.references :video_content

      t.timestamps
    end
  end

  def self.down
    drop_table :video_posters
  end
end
