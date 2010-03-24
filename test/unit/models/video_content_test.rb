require 'test_helper'

class VideoContentTest < ActiveSupport::TestCase

  should_validate_presence_of :name, :state
  should_have_many :video_file_references
  should_have_many :video_posters
  should_have_and_belong_to_many :genres

  should 'return a formated runtime' do
    movie = Movie.new
    assert_equal '', movie.runtime_formatted
    movie.runtime = 30
    assert_equal '30m', movie.runtime_formatted
    movie.runtime = 60
    assert_equal '1h', movie.runtime_formatted
    movie.runtime = 90
    assert_equal '1h 30m', movie.runtime_formatted
  end

  should 'find movie poster' do
    movie = Movie.new
    assert_nil movie.poster('small')
    movie.video_posters = [VideoPoster.new(:size => 'large')]
    assert_nil movie.poster('small')
    small_poster = VideoPoster.new(:size => 'small')
    movie.video_posters << small_poster
    assert_equal small_poster, movie.poster('small')
  end

  should 'return state display name' do
    assert_equal 'Pending', VideoContentState.display_name(:pending)
  end 
  
  should 'return state select values' do
    assert_not_nil VideoContentState.select_values
  end  

end
