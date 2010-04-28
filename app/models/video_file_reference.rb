class VideoFileReference < ActiveRecord::Base
  validates_presence_of :location, :media_folder_id
  validates_uniqueness_of :location
  belongs_to :media_folder
  belongs_to :video_content
  has_many :video_file_properties
  
  def video_content_name
    return self.video_content.name unless not self.video_content
  end
  
  def <=>(other)
    return 1 if other.nil? || other.location.nil?
    return -1 if location.nil?
      
    this_info = Util::FileNameCleaner.get_name_info(location)
    other_info = Util::FileNameCleaner.get_name_info(other.location)
    return this_info <=> other_info
  end

end