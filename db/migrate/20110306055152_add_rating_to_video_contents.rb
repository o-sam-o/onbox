class AddRatingToVideoContents < ActiveRecord::Migration
  def self.up
    add_column :video_contents, :rating, :decimal
  end

  def self.down
    remove_column :video_contents, :rating
  end
end
