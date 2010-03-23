require 'test_helper'

class TvEpisodeTest < ActiveSupport::TestCase

  should_belong_to :tv_show
  should_belong_to :video_file_reference

end
