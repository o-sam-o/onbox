class VideoFileReference < ActiveRecord::Base
  validates_presence_of :location
  belongs_to :media_folder
  belongs_to :video_content
end