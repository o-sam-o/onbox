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
  
  should 'validate uniqueness of an imdb id' do
    movie = Movie.new
    assert movie.unique_imdb_id?('asdfasd000')
  end
  
  should 'validate if imdb id already exists' do
    movie = Movie.new
    assert !movie.unique_imdb_id?('TEST_ID')
  end
  
  should 'pass imdb id uniqueness if has the same id as the existing one' do
    movie = VideoContent.find_by_imdb_id('TEST_ID')
    assert movie.unique_imdb_id?('TEST_ID')
  end
  
  should 'merge into existing video content with the same imdb id' do
    # clean up any previous leftover
    existing = VideoContent.find_by_imdb_id('dup_test')
    existing.destroy if existing
    existing = VideoContent.find_by_name('dup test 2')
    existing.destroy if existing    
    
    media_folder = MediaFolder.find_or_create_by_location('/dup/test')
    movie1 = Movie.create!(:name => 'dup test', :state => 'pending', :imdb_id => 'dup_test')
    movie1.video_file_references << VideoFileReference.create!(:location => Time.now.to_s, :media_folder => media_folder)
    movie1.save!
    assert_equal 1, movie1.video_file_references.size
    
    movie2 = Movie.create!(:name => 'dup test 2', :state => 'pending')
    movie2.video_file_references << VideoFileReference.create!(:location => Time.now.to_s + '-2', :media_folder => media_folder)
    movie2.save!
    assert_equal 1, movie1.video_file_references.size
    
    movie2.merge_with_imdb_id('dup_test')
    
    assert_equal 2, movie1.video_file_references(true).size
    assert_nil VideoContent.find_by_name('dup test 2')
  end  
end
