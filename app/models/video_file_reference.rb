class VideoFileReference < ActiveRecord::Base
  validates_presence_of :location
  belongs_to :media_folder
  belongs_to :video_content
  
  def video_content_name
    return self.video_content.name unless not self.video_content
  end
  
  def video_content_name=(name)
    self.video_content = VideoContent.find_by_name(name) unless name.blank?
  end
end