class CreateVideoFileProperties < ActiveRecord::Migration
  def self.up
    create_table :video_file_properties do |t|
      t.string :name
      t.string :value
      t.integer :order
      t.references :video_file_reference

      t.timestamps
    end
  end

  def self.down
    drop_table :video_file_properties
  end
end
