require 'test_helper'

class VideoContentTest < ActiveSupport::TestCase

  should_validate_presence_of :name, :state
  should_have_many :video_file_references
  should_have_many :video_posters
  should_have_and_belong_to_many :genres

end
