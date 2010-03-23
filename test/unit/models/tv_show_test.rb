require 'test_helper'

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

end