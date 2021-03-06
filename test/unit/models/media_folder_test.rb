require File.dirname(__FILE__) + '/../../test_helper'

class MediaFolderTest < ActiveSupport::TestCase

  should_have_many :video_file_references
  should_validate_presence_of :location
  should_validate_uniqueness_of :location

end
