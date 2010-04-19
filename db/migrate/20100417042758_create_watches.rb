class CreateWatches < ActiveRecord::Migration
  def self.up
    create_table :watches do |t|
      t.references :user
      t.references :video_content

      t.timestamps
    end
  end

  def self.down
    drop_table :watches
  end
end
