require 'test/unit'
require "lib/util/imdb_metadata_scraper"

class ImdbMetadataScraperTest < Test::Unit::TestCase
  
  should 'should find movie imdb id with name and year' do
    movie_name = 'Starsky & Hutch'
    ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '0335438', ImdbMetadataScraper.search_for_imdb_id(movie_name, 2004)
    
    ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '1380813', ImdbMetadataScraper.search_for_imdb_id(movie_name, 2003)
  end

  should 'should find movie imdb id with name only' do
    movie_name = 'Starsky & Hutch'
    ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '0335438', ImdbMetadataScraper.search_for_imdb_id(movie_name, nil)
  end
  
  should 'should return nil if not matching year' do
    movie_name = 'Starsky & Hutch'
    ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal nil, ImdbMetadataScraper.search_for_imdb_id(movie_name, 2099)
  end  
  
  should 'should find tv show imdb id with name only' do
    movie_name = 'Starsky & Hutch'
    ImdbMetadataScraper.expects(:get_search_page).with(movie_name).returns(open(File.join(File.dirname(__FILE__), 'starkey_hutch_search.html')) { |f| Hpricot(f) })
    assert_equal '0072567', ImdbMetadataScraper.search_for_imdb_id(movie_name, nil, true)
  end  

end