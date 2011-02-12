require File.dirname(__FILE__) + '/../../test_helper'

class MovieTest < ActiveSupport::TestCase

  should "answer true to movie?" do
    movie = Movie.new
    assert movie.movie?
  end

  should "answer false to tv_show?" do
    movie = Movie.new
    assert !movie.tv_show?
  end

end
