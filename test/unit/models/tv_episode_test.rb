require File.dirname(__FILE__) + '/../../test_helper'

class TvEpisodeTest < ActiveSupport::TestCase

  should_belong_to :tv_show
  should_belong_to :video_file_reference

  should 'sort based on episode and tv series' do
    s1e1 = TvEpisode.new(:series => 1, :episode => 1)
    s1e2 = TvEpisode.new(:series => 1, :episode => 2)
    s2e1 = TvEpisode.new(:series => 2, :episode => 1)
    
    assert (s1e1 <=> s1e1) == 0
    assert (s1e1 <=> s1e2) < 0
    assert (s1e2 <=> s1e1) > 0
    assert (s2e1 <=> s1e2) > 0
  end  

end
