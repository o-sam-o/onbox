class AddGroupToVideoFileProperties < ActiveRecord::Migration
  def self.up
    add_column :video_file_properties, :group, :string
  end

  def self.down
    remove_column :video_file_properties, :group
  end
end
