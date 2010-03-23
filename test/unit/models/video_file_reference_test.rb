require 'test_helper'

class VideoFileReferenceTest < ActiveSupport::TestCase
  should_validate_presence_of :location
  should_belong_to :media_folder, :video_content
  should_have_many :video_file_properties
end
