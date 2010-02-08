class CreateMediaFolders < ActiveRecord::Migration
  def self.up
    create_table :media_folders do |t|
      t.string :location
      t.boolean :scan

      t.timestamps
    end
  end

  def self.down
    drop_table :media_folders
  end
end
