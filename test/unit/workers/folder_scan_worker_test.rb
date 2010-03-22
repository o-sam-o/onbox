require File.join(File.dirname(__FILE__), "/../../bdrb_test_helper")
require "lib/workers/scrap_imdb_worker" 
require "hpricot"
require 'mocha'

class WalkerTest < Test::Unit::TestCase

  def test_poster_file_name
    worker = ScrapImdbWorker.new
    assert_equal('movie.name.2000.size.mp4', worker.send(:poster_file_name, 'movie name', 2000, 'size', '.mp4'))
    assert_equal('movie.name.2000.size', worker.send(:poster_file_name, 'movie name', 2000, 'size', nil))
    assert_equal('movie.name.size.mp4', worker.send(:poster_file_name, 'movie name', nil, 'size', '.mp4'))
    assert_equal('movie_name.2000.size.avi', worker.send(:poster_file_name, 'movie_name', 2000, 'size', '.avi'))
    assert_equal('movie.name3.2000.size.mp4', worker.send(:poster_file_name, 'movie name!3%\\/', 2000, 'size', '.mp4'))
    assert_equal('movie.name.10.size.mp4', worker.send(:poster_file_name, 'movie name', 10, 'size', '.mp4'))
    assert_equal('movie.name.2000.small.mp4', worker.send(:poster_file_name, 'movie name', 2000, 'small', '.mp4'))
    assert_equal('movie.name.2000.size.2.mp4', worker.send(:poster_file_name, 'movie name', 2000, 'size', '.mp4', 2))
    assert_equal('movie.name.2000.size.mp4', worker.send(:poster_file_name, 'Movie Name', 2000, 'size', '.mp4'))
  end
  
  def test_scrap_imdb_movie
    imdb_id = '0499549'
    ImdbMetadataScraper.expects(:get_movie_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), 'Avatar.2009.html')) { |f| Hpricot(f) })
    Genre.expects(:find_or_create_by_name).with('Action').returns(Genre.new({:name => 'Action'}))
    Genre.expects(:find_or_create_by_name).with('Adventure').returns(Genre.new({:name => 'Adventure'}))
    Genre.expects(:find_or_create_by_name).with('Sci-Fi').returns(Genre.new({:name => 'Sci-Fi'}))
    
    video_content = Movie.new({:name => 'Fake Name', :imdb_id => imdb_id})
    video_content.expects(:save!).returns(true)
    
    worker = ScrapImdbWorker.new
    worker.send(:scrap_imdb, video_content)
    
    assert_equal('Avatar', video_content.name)
    assert_equal(imdb_id, video_content.imdb_id)
    assert_equal(2009, video_content.year)
    assert_equal(Date.new(y=2009,m=12,d=17), video_content.release_date)  
    assert_equal('A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.', video_content.plot)  
    assert_equal('James Cameron', video_content.director)
    assert_equal('Enter the World', video_content.tag_line)
    assert_equal('English', video_content.language)
    assert_equal(162, video_content.runtime)
  end  
  
  def test_scrap_imdb_tv_show
    imdb_id = '0411008'
    ImdbMetadataScraper.expects(:get_movie_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), 'Lost.2004.html')) { |f| Hpricot(f) })
    ImdbMetadataScraper.expects(:get_episodes_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), 'Lost.2004.Episodes.html')) { |f| Hpricot(f) })

    Genre.expects(:find_or_create_by_name).with('Adventure').returns(Genre.new(:name => 'Adventure'))
    Genre.expects(:find_or_create_by_name).with('Drama').returns(Genre.new(:name => 'Drama'))
    Genre.expects(:find_or_create_by_name).with('Mystery').returns(Genre.new(:name => 'Mystery'))
    Genre.expects(:find_or_create_by_name).with('Sci-Fi').returns(Genre.new(:name => 'Sci-Fi'))
    Genre.expects(:find_or_create_by_name).with('Thriller').returns(Genre.new(:name => 'Thriller'))
    
    video_content = TvShow.new({:name => 'Fake Name', :imdb_id => imdb_id})
    video_content.expects(:save!).returns(true)

    tv_episodes_mock = mock()
    video_content.stubs(:tv_episodes).returns(tv_episodes_mock)
    tv_episodes_mock.stubs(:find).returns(nil)
    tv_episodes_mock.expects(:create!).times(116).returns(TvEpisode.new(:title => 'Mocked'))
    tv_episodes_mock.expects(:replace)
    
    worker = ScrapImdbWorker.new
    worker.send(:scrap_imdb, video_content)
    
    assert_equal('"Lost"', video_content.name)
    assert_equal(imdb_id, video_content.imdb_id)
    assert_equal(2004, video_content.year)
    assert_equal(nil, video_content.release_date)  
    assert_equal("The survivors of a plane crash are forced to live with each other on a remote island, a dangerous new world that poses unique threats of its own.", video_content.plot)  
    assert_equal(nil, video_content.director)
    assert_equal("They're not the survivors they think they are. (Season Two)", video_content.tag_line)
    assert_equal('English', video_content.language)
    assert_equal(42, video_content.runtime)
  end  

end
