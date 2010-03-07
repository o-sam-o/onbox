class VideoFileProperty < ActiveRecord::Base
  validates_presence_of :name, :value
  belongs_to :video_file_reference
end
