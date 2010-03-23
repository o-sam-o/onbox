require 'test_helper'

class VideoPosterTest < ActiveSupport::TestCase
  should_validate_presence_of :size, :location
  should_belong_to :video_content
end
