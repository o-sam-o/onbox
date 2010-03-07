class VideoFileReference < ActiveRecord::Base
  validates_presence_of :location
  belongs_to :media_folder
  belongs_to :video_content
  has_many :video_file_properties
  
  def video_content_name
    return self.video_content.name unless not self.video_content
  end
end