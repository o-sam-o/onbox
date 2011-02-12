require File.dirname(__FILE__) + '/../../test_helper'

class TvShowTest < ActiveSupport::TestCase

  should_have_many :tv_episodes

  should "answer false to movie?" do
    show = TvShow.new
    assert !show.movie?
  end

  should "answer true to tv_show?" do
    show = TvShow.new
    assert show.tv_show?
  end
  
  should "group tv episodes by series" do
    show = TvShow.new
    s1e1 = TvEpisode.new(:series => 1, :episode => 1)
    s1e2 = TvEpisode.new(:series => 1, :episode => 2)
    s1e3 = TvEpisode.new(:series => 1, :episode => 3)
    s2e1 = TvEpisode.new(:series => 2, :episode => 1)
    show.tv_episodes << s2e1
    show.tv_episodes << s1e1
    show.tv_episodes << s1e3
    show.tv_episodes << s1e2
    
    grouped = show.tv_episodes.group_by_series
    
    assert_equal 2, grouped.size
    assert_equal ({ 1 => [s1e1, s1e2, s1e3], 2 => [s2e1] }, grouped)
  end  

end
