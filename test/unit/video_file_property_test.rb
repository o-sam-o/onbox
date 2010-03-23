require 'test_helper'

class VideoFilePropertyTest < ActiveSupport::TestCase
  should_validate_presence_of :name, :value
  should_belong_to :video_file_reference
end
