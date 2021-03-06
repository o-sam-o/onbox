require File.join(File.dirname(__FILE__), "/../../bdrb_test_helper")

class ScrapImdbWorkerTest < Test::Unit::TestCase

  def setup
    YayImdbs.stubs(:get_media_page).returns(stubbed_page_result('media_page.html'))
  end

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
    YayImdbs.expects(:get_movie_page).with(imdb_id).returns(stubbed_page_result('Avatar.2009.html'))
    Genre.expects(:find_or_create_by_name).with('Action').returns(Genre.new({:name => 'Action'}))
    Genre.expects(:find_or_create_by_name).with('Adventure').returns(Genre.new({:name => 'Adventure'}))
    Genre.expects(:find_or_create_by_name).with('Sci-Fi').returns(Genre.new({:name => 'Sci-Fi'}))
    Genre.expects(:find_or_create_by_name).with('Fantasy').returns(Genre.new({:name => 'Sci-Fi'}))
    
    video_content = Movie.new({:name => 'Fake Name', :imdb_id => imdb_id})
    video_content.expects(:unique_imdb_id?).returns(true)    
    video_content.expects(:save!).returns(true)
    
    worker = ScrapImdbWorker.new
    worker.send(:scrap_imdb, video_content)
    
    assert_equal('Avatar', video_content.name)
    assert_equal(imdb_id, video_content.imdb_id)
    assert(video_content.movie?)
    assert_equal(2009, video_content.year)
    assert_equal(Date.new(y=2009,m=12,d=17), video_content.release_date)  
    assert_equal('A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.', video_content.plot)  
    assert_equal('James Cameron', video_content.director)
    assert_equal('Return to Pandora', video_content.tag_line)
    assert_equal('English', video_content.language)
    assert_equal(162, video_content.runtime)
  end  
  
  should 'scrap tv show details' do
    imdb_id = '0411008'
    YayImdbs.expects(:get_movie_page).with(imdb_id).returns(stubbed_page_result('Lost.2004.html'))
    YayImdbs.expects(:get_episodes_page).with(imdb_id).returns(stubbed_page_result('Lost.2004.Episodes.html'))

    Genre.expects(:find_or_create_by_name).with('Adventure').returns(Genre.new(:name => 'Adventure'))
    Genre.expects(:find_or_create_by_name).with('Drama').returns(Genre.new(:name => 'Drama'))
    Genre.expects(:find_or_create_by_name).with('Mystery').returns(Genre.new(:name => 'Mystery'))
    Genre.expects(:find_or_create_by_name).with('Sci-Fi').returns(Genre.new(:name => 'Sci-Fi'))
    Genre.expects(:find_or_create_by_name).with('Thriller').returns(Genre.new(:name => 'Thriller'))
    
    video_content = TvShow.new({:name => 'Fake Name', :imdb_id => imdb_id})
    video_content.expects(:unique_imdb_id?).returns(true)
    video_content.expects(:save!).returns(true)
    video_file_ref = VideoFileReference.new(:location => '/test/LostS01E02.avi')
    video_content.expects(:video_file_references).twice.returns([video_file_ref])

    tv_episodes_mock = mock('tv_episode')
    video_content.stubs(:tv_episodes).returns(tv_episodes_mock)
    tv_episodes_mock.stubs(:find).returns(nil)
    tv_episodes_mock.expects(:create!).times(114).returns(TvEpisode.new(:title => 'Mocked'))
    tv_episodes_mock.expects(:replace)
    
    worker = ScrapImdbWorker.new
    worker.send(:scrap_imdb, video_content)
    
    assert_equal('Lost', video_content.name)
    assert_equal(imdb_id, video_content.imdb_id)
    assert(video_content.tv_show?)    
    assert_equal(2004, video_content.year)
    assert_equal(nil, video_content.release_date)  
    assert_equal("The survivors of a plane crash are forced to live with each other on a remote island, a dangerous new world that poses unique threats of its own.", video_content.plot)  
    assert_equal(nil, video_content.director)
    assert_equal("Destiny Found (Season 6)", video_content.tag_line)
    assert_equal('English', video_content.language)
    assert_equal(42, video_content.runtime)
  end
  
  should 'should support changing video type if imdb id if for other type' do
    imdb_id = '0411008'
    YayImdbs.expects(:get_movie_page).with(imdb_id).returns(stubbed_page_result('Lost.2004.html'))
    YayImdbs.expects(:get_episodes_page).with(imdb_id).returns(stubbed_page_result('Lost.2004.Episodes.html'))

    Genre.expects(:find_or_create_by_name).with('Adventure').returns(Genre.new(:name => 'Adventure'))
    Genre.expects(:find_or_create_by_name).with('Drama').returns(Genre.new(:name => 'Drama'))
    Genre.expects(:find_or_create_by_name).with('Mystery').returns(Genre.new(:name => 'Mystery'))
    Genre.expects(:find_or_create_by_name).with('Sci-Fi').returns(Genre.new(:name => 'Sci-Fi'))
    Genre.expects(:find_or_create_by_name).with('Thriller').returns(Genre.new(:name => 'Thriller'))
    
    video_content = Movie.new(:name => 'Fake Name', :imdb_id => imdb_id)
    video_content.expects(:unique_imdb_id?).returns(true)
    video_content.expects(:change_type).with('TvShow')
    video_content.expects(:save!).returns(true)
    VideoContent.expects(:find).returns(video_content)
    video_file_ref = VideoFileReference.new(:location => '/test/LostS01E02.avi')
    video_content.expects(:video_file_references).twice.returns([video_file_ref])

    tv_episodes_mock = mock()
    video_content.stubs(:tv_episodes).returns(tv_episodes_mock)
    tv_episodes_mock.stubs(:find).returns(nil)
    tv_episodes_mock.expects(:create!).times(114).returns(TvEpisode.new(:title => 'Mocked'))
    tv_episodes_mock.expects(:replace)
    
    worker = ScrapImdbWorker.new
    worker.send(:scrap_imdb, video_content)
    
    assert_equal('Lost', video_content.name)
    assert_equal(imdb_id, video_content.imdb_id)
    assert_equal(2004, video_content.year)
  end  
  
  should 'not search imdb if imdb id already in video content' do
    YayImdbs.expects(:search_for_imdb_id).never
    
    worker = ScrapImdbWorker.new
    imdb_id = worker.send(:get_imdb_id, Movie.new(:imdb_id => 'fake id'))
    
    assert_equal('fake id', imdb_id)
  end
  
  should 'search imdb if no imdb id in video content' do
    YayImdbs.expects(:search_for_imdb_id).with('name', 2000, :movie).returns('fake id')
    
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
    YayImdbs.expects(:search_for_imdb_id).returns(nil)
    
    worker = ScrapImdbWorker.new        
    worker.scrap_all_pending
    assert_equal movie.state, 'no_imdb_id'
  end  
  
  should 'merge duplicate video contents if scraping returns an existing imdb id' do
    movie = Movie.new
    VideoContent.expects(:find_all_by_state).with('pending').returns([movie])
    YayImdbs.expects(:search_for_imdb_id).returns('existing')
    movie.expects(:unique_imdb_id?).with('existing').returns(false)
    movie.expects(:merge_with_imdb_id).with('existing')
    
    worker = ScrapImdbWorker.new        
    worker.scrap_all_pending
    assert true
  end  
 
  def stubbed_page_result(stub_file)
    open(File.join(File.dirname(__FILE__), stub_file)) { |f| Nokogiri::HTML(f) }
  end

end
