class CreateVideoFileReferences < ActiveRecord::Migration
  def self.up
    create_table :video_file_references do |t|
      t.string :raw_name
      t.string :location
      t.boolean :on_disk
      t.references :media_folder
      t.references :video_content

      t.timestamps
    end
  end

  def self.down
    drop_table :video_file_references
  end
end
