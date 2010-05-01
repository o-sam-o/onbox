require 'test/unit'

class Util::ImdbMetadataScraperTest < Test::Unit::TestCase
  
  should 'should find movie imdb id with name and year' do
    movie_name = 'Starsky & Hutch'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '0335438', Util::ImdbMetadataScraper.search_for_imdb_id(movie_name, 2004)
    
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '1380813', Util::ImdbMetadataScraper.search_for_imdb_id(movie_name, 2003)
  end

  should 'should find movie imdb id with name only' do
    movie_name = 'Starsky & Hutch'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '0335438', Util::ImdbMetadataScraper.search_for_imdb_id(movie_name, nil)
  end
  
  should 'should return nil if not matching year' do
    movie_name = 'Starsky & Hutch'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal nil, Util::ImdbMetadataScraper.search_for_imdb_id(movie_name, 2099)
  end  
  
  should 'should find tv show imdb id with name only' do
    movie_name = 'Starsky & Hutch'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '0072567', Util::ImdbMetadataScraper.search_for_imdb_id(movie_name, nil, true)
  end  
  
  should 'find the imdb id when search redirects directly to the movie page' do
    movie_name = 'Avatar'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), '../workers/Avatar.2009.html')) { |f| Hpricot(f) })
    assert_equal '0499549', Util::ImdbMetadataScraper.search_for_imdb_id(movie_name, nil, false)  
  end  

  should 'not find result if incorrect video type' do
    movie_name = 'Avatar'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), '../workers/Avatar.2009.html')) { |f| Hpricot(f) })
    # We want a tv show but a movie is returned
    assert_equal nil, Util::ImdbMetadataScraper.search_for_imdb_id(movie_name, nil, true)  
  end

  should 'search imdb and return name, year and id' do
    movie_name = 'Starsky & Hutch'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    search_results = Util::ImdbMetadataScraper.search_imdb(movie_name)
    assert_equal [{:name => 'Starsky & Hutch', :year => 2004, :imdb_id => '0335438', :video_type => :movie},
                  {:name => 'Starsky and Hutch', :year => 1975, :imdb_id => '0072567', :video_type => :tv_show},
                  {:name => 'Starsky & Hutch', :year => 2003, :imdb_id => '1380813', :video_type => :movie},
                  {:name => 'Starsky & Hutch: A Last Look', :year => 2004, :imdb_id => '0488639', :video_type => :movie},
                  {:name => 'Starsky & Hutch Documentary: The Word on the Street', :year => 1999, :imdb_id => '1393834', :video_type => :tv_show},
                  {:name => 'TV Guide Specials: Starsky & Hutch', :year => 2004, :imdb_id => '0464230', :video_type => :tv_show},
                  {:name => "He's Starsky, I'm Hutch", :year => 2004, :imdb_id => '1540121', :video_type => :tv_show},
                  {:name => 'The Real Story of Butch Cassidy and the Sundance Kid', :year => 1993, :imdb_id => '0401745', :video_type => :movie},
                  {:name => "Le boucher, la star et l'orpheline", :year => 1975, :imdb_id => '0069819', :video_type => :movie},
                  {:name => "Hutch Stirs 'em Up", :year => 1923, :imdb_id => '0290216', :video_type => :movie},
                  {:name => 'Love and Hate: The Story of Colin and Joanne Thatcher', :year => 1989, :imdb_id => '0097788', :video_type => :tv_show}], 
                  search_results                  
  end  

  should 'search imdb and return name, year and id even for exact search result' do
    movie_name = 'Avatar'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), '../workers/Avatar.2009.html')) { |f| Hpricot(f) })
    search_results = Util::ImdbMetadataScraper.search_imdb(movie_name)
    assert_equal [{:name => 'Avatar', :year => 2009, :imdb_id => '0499549', :video_type => :movie}], search_results                  
  end

  should 'search imdb and return name, year and id even for exact tv show search result' do
    movie_name = 'Lost'
    Util::ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), '../workers/Lost.2004.html')) { |f| Hpricot(f) })
    search_results = Util::ImdbMetadataScraper.search_imdb(movie_name)
    assert_equal [{:name => 'Lost', :year => 2004, :imdb_id => '0411008', :video_type => :tv_show}], search_results                  
  end
  
  should 'detect tv show type' do
    imdb_id = '0411008'
    Util::ImdbMetadataScraper.expects(:get_movie_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), '../workers/Lost.2004.html')) { |f| Hpricot(f) })
    Util::ImdbMetadataScraper.expects(:get_episodes_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), '../workers/Lost.2004.Episodes.html')) { |f| Hpricot(f) })
    
    show_info = Util::ImdbMetadataScraper.scrap_movie_info(imdb_id)
    assert_equal :tv_show, show_info['video_type']
  end  
  
  should 'detect movie type' do
    imdb_id = '0499549'
    Util::ImdbMetadataScraper.expects(:get_movie_page).with(imdb_id).returns(open(File.join(File.dirname(__FILE__), '../workers/Avatar.2009.html')) { |f| Hpricot(f) })
    
    movie_info = Util::ImdbMetadataScraper.scrap_movie_info(imdb_id)
    assert_equal :movie, movie_info['video_type']
  end  

end