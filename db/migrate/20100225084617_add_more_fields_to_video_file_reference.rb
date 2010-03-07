class AddMoreFieldsToVideoFileReference < ActiveRecord::Migration
  def self.up
    add_column :video_file_references, :size, :integer
    add_column :video_file_references, :format, :string
  end

  def self.down
    remove_column :video_file_references, :size
    remove_column :video_file_references, :format
  end
end
