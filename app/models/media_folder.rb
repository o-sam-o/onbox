class MediaFolder < ActiveRecord::Base
  validates_presence_of :location
  validates_uniqueness_of :location
  has_many :video_file_references
end
