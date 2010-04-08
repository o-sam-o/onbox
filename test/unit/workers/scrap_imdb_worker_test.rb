require File.join(File.dirname(__FILE__), "/../../bdrb_test_helper")
require "lib/workers/scrap_imdb_worker" 
require "hpricot"
require 'mocha'
require 'fakefs/safe'

class ScrapImdbWorkerTest < Test::Unit::TestCase

  should 'create meaningful and valid poster names' do
    worker = ScrapImdbWorker.new
    storage_location = '/test/dir'
    worker.stubs(:storage_dir).returns(storage_location)
    
    assert_equal('movie.name.2000.size.mp4', worker.send(:poster_file_name, 'movie name', 2000, 'size', '.mp4'))
    assert_equal('movie.name.2000.size', worker.send(:poster_file_name, 'movie name', 2000, 'size', nil))
    assert_equal('movie.name.size.mp4', worker.send(:poster_file_name, 'movie name', nil, 'size', '.mp4'))
    assert_equal('movie_name.2000.size.avi', worker.send(:poster_file_name, 'movie_name', 2000, 'size', '.avi'))
    assert_equal('movie.name3.2000.size.mp4', worker.send(:poster_file_name, 'movie name!3%\\/', 2000, 'size', '.mp4'))
    assert_equal('movie.name.10.size.mp4', worker.send(:poster_file_name, 'movie name', 10, 'size', '.mp4'))
    assert_equal('movie.name.2000.small.mp4', worker.send(:poster_file_name, 'movie name', 2000, 'small', '.mp4'))
    assert_equal('movie.name.2000.size.mp4', worker.send(:poster_file_name, 'Movie Name', 2000, 'size', '.mp4'))
    
    # Test case of file name already taken
    FakeFS do
      FileUtils.mkdir_p(storage_location)
      FileUtils.touch("#{storage_location}/movie.name.2000.size.mp4")
      assert_equal("movie.name.2000.size.2.mp4", worker.send(:poster_file_name, 'movie name', 2000, 'size', '.mp4'))
    end
  end
  
  should 'scrap movie details' do
    imdb_id = '0499549'
    ImdbMetadataScraper.expects(:get_movie_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), 'Avatar.2009.html')) { |f| Hpricot(f) })
    Genre.expects(:find_or_create_by_name).with('Action').returns(Genre.new({:name => 'Action'}))
    Genre.expects(:find_or_create_by_name).with('Adventure').returns(Genre.new({:name => 'Adventure'}))
    Genre.expects(:find_or_create_by_name).with('Sci-Fi').returns(Genre.new({:name => 'Sci-Fi'}))
    
    video_content = Movie.new({:name => 'Fake Name', :imdb_id => imdb_id})
    video_content.expects(:unique_imdb_id?).returns(true)    
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
  
  should 'scrap tv show details' do
    imdb_id = '0411008'
    ImdbMetadataScraper.expects(:get_movie_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), 'Lost.2004.html')) { |f| Hpricot(f) })
    ImdbMetadataScraper.expects(:get_episodes_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), 'Lost.2004.Episodes.html')) { |f| Hpricot(f) })

    Genre.expects(:find_or_create_by_name).with('Adventure').returns(Genre.new(:name => 'Adventure'))
    Genre.expects(:find_or_create_by_name).with('Drama').returns(Genre.new(:name => 'Drama'))
    Genre.expects(:find_or_create_by_name).with('Mystery').returns(Genre.new(:name => 'Mystery'))
    Genre.expects(:find_or_create_by_name).with('Sci-Fi').returns(Genre.new(:name => 'Sci-Fi'))
    Genre.expects(:find_or_create_by_name).with('Thriller').returns(Genre.new(:name => 'Thriller'))
    
    video_content = TvShow.new({:name => 'Fake Name', :imdb_id => imdb_id})
    video_content.expects(:unique_imdb_id?).returns(true)
    video_content.expects(:save!).returns(true)


    tv_episodes_mock = mock()
    video_content.stubs(:tv_episodes).returns(tv_episodes_mock)
    tv_episodes_mock.stubs(:find).returns(nil)
    tv_episodes_mock.expects(:create!).times(116).returns(TvEpisode.new(:title => 'Mocked'))
    tv_episodes_mock.expects(:replace)
    
    worker = ScrapImdbWorker.new
    worker.send(:scrap_imdb, video_content)
    
    assert_equal('Lost', video_content.name)
    assert_equal(imdb_id, video_content.imdb_id)
    assert_equal(2004, video_content.year)
    assert_equal(nil, video_content.release_date)  
    assert_equal("The survivors of a plane crash are forced to live with each other on a remote island, a dangerous new world that poses unique threats of its own.", video_content.plot)  
    assert_equal(nil, video_content.director)
    assert_equal("They're not the survivors they think they are. (Season Two)", video_content.tag_line)
    assert_equal('English', video_content.language)
    assert_equal(42, video_content.runtime)
  end
  
  should 'not search imdb if imdb id already in video content' do
    ImdbMetadataScraper.expects(:search_for_imdb_id).never
    
    worker = ScrapImdbWorker.new
    imdb_id = worker.send(:get_imdb_id, Movie.new(:imdb_id => 'fake id'))
    
    assert_equal('fake id', imdb_id)
  end
  
  should 'search imdb if no imdb id in video content' do
    ImdbMetadataScraper.expects(:search_for_imdb_id).with('name', 2000).returns('fake id')
    
    worker = ScrapImdbWorker.new
    imdb_id = worker.send(:get_imdb_id, Movie.new(:name => 'name', :year => 2000))
    
    assert_equal('fake id', imdb_id)
  end  
  
  should 'scrap all pending video contents' do
    movie = Movie.new
    tv_show = TvShow.new
    VideoContent.expects(:find_all_by_state).with('pending').returns([movie, tv_show])
    worker = ScrapImdbWorker.new
    worker.expects(:scrap_imdb).with(movie)
    worker.expects(:scrap_imdb).with(tv_show)
    worker.scrap_all_pending
  end  
  
  should 'continue scraping pending even if an exception is raised' do
    movie = Movie.new
    tv_show = TvShow.new
    VideoContent.expects(:find_all_by_state).with('pending').returns([movie, tv_show])
    worker = ScrapImdbWorker.new
    worker.expects(:scrap_imdb).raises
    worker.expects(:scrap_imdb).with(tv_show)
    worker.scrap_all_pending
  end
  
  should 'scrap a single video content' do
    movie = Movie.new
    VideoContent.expects(:find).with(1).returns(movie)
    worker = ScrapImdbWorker.new
    worker.expects(:scrap_imdb).with(movie)
    
    worker.scrap_for_video_content(1)
  end  
  
  should 'gracefully handle exceptions when scrap a single video content' do
    movie = Movie.new
    VideoContent.expects(:find).with(1).returns(movie)
    worker = ScrapImdbWorker.new
    worker.expects(:scrap_imdb).raises
    worker.scrap_for_video_content(1)
  end
  
  should 'set state to no imdb id if imdb seach fails' do
    movie = Movie.new
    VideoContent.expects(:find_all_by_state).with('pending').returns([movie])
    ImdbMetadataScraper.expects(:search_for_imdb_id).returns(nil)
    
    worker = ScrapImdbWorker.new        
    worker.scrap_all_pending
    assert_equal movie.state, VideoContentState::NO_IMDB_ID
  end  
  
  should 'merge duplicate video contents if scraping returns an existing imdb id' do
    movie = Movie.new
    VideoContent.expects(:find_all_by_state).with('pending').returns([movie])
    ImdbMetadataScraper.expects(:search_for_imdb_id).returns('existing')
    movie.expects(:unique_imdb_id?).with('existing').returns(false)
    movie.expects(:merge_with_imdb_id).with('existing')
    
    worker = ScrapImdbWorker.new        
    worker.scrap_all_pending
    assert true
  end  
  
end
