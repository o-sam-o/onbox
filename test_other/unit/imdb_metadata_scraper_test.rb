#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'test/unit'
require 'active_support'
require 'htmlentities'
require "lib/util/imdb_metadata_scraper"

class ImdbMetadataScraperTest < Test::Unit::TestCase

  def test_search_for_imdb_id
    puts "Search 1"
    assert_equal('0146882', Util::ImdbMetadataScraper.search_for_imdb_id('High Fidelity', 2000))
    puts "Search 2"
    assert_equal('0146882', Util::ImdbMetadataScraper.search_for_imdb_id('High Fidelity', nil))
    puts "Search 3"
    assert_equal('0206807', Util::ImdbMetadataScraper.search_for_imdb_id('High Fidelity', 1976))
    puts "Search 4"
    assert_equal('0146882', Util::ImdbMetadataScraper.search_for_imdb_id('High Fidelity limited', 2000))
    
    #Test year format (2009/I)    
    puts "Search 5"
    assert_equal('0362478', Util::ImdbMetadataScraper.search_for_imdb_id('The Box', 2009))
    puts "Search 6"
    assert_equal('0321512', Util::ImdbMetadataScraper.search_for_imdb_id('The Box', 2000))
    
    puts "Search 7"
    assert_nil(Util::ImdbMetadataScraper.search_for_imdb_id('High Fidelity', 3000))
    
    #Test search that redirects directly to the movie page
    puts "Search 8"
    assert_equal('1018818', Util::ImdbMetadataScraper.search_for_imdb_id('Assassination of a High School President', 2008))
  end

  def test_scrap_movie_info_the_box
    puts "Scraping info"
    movie_info = Util::ImdbMetadataScraper.scrap_movie_info('0362478')
    assert_equal('The Box', movie_info['title'])
    assert_equal(2009, movie_info['year'])
    assert_equal(Date.new(y=2009,m=10,d=29), movie_info['release date'])
    assert_equal("A small wooden box arrives on the doorstep of a married couple, who know that opening it will grant them a million dollars and kill someone they don't know.", movie_info['plot'])
    
    assert_not_nil(movie_info['small_image'])
    assert_not_nil(movie_info['large_image'])
  end

end