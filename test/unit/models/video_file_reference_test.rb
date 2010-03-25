require 'test_helper'

class VideoFileReferenceTest < ActiveSupport::TestCase
  should_validate_presence_of :location
  should_validate_uniqueness_of :location
  should_belong_to :media_folder, :video_content
  should_have_many :video_file_properties
  
  should 'return content name' do
    reference = VideoFileReference.new
    assert_equal nil, reference.video_content_name
    reference.video_content = Movie.new(:name => 'test name')
    assert_equal 'test name', reference.video_content_name
  end
end
