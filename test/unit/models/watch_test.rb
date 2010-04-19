require 'test_helper'

class WatchTest < ActiveSupport::TestCase
  should_belong_to :video_content, :user
end
