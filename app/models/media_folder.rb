class MediaFolder < ActiveRecord::Base
  validates_presence_of :location, :scan
  has_many: :video_file_references
end
