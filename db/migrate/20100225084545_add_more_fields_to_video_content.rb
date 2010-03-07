class AddMoreFieldsToVideoContent < ActiveRecord::Migration
  def self.up
    add_column :video_contents, :runtime, :integer
    add_column :video_contents, :director, :string
    add_column :video_contents, :language, :string
    add_column :video_contents, :tag_line, :string
  end

  def self.down
    remove_column :video_contents, :runtime
    remove_column :video_contents, :director
    remove_column :video_contents, :language
    remove_column :video_contents, :tag_line   
  end
end
