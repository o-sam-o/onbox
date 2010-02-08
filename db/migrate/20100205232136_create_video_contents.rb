class CreateVideoContents < ActiveRecord::Migration
  def self.up
    create_table :video_contents do |t|
      t.string :name
      t.integer :year
      t.date :release_date
      t.string :plot
      t.string :state
      t.string :imdb_id

      t.timestamps
    end
  end

  def self.down
    drop_table :video_contents
  end
end
