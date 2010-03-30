#!/usr/bin/env ruby

require 'cgi'
require 'rubygems'
require 'hpricot'
require 'test/unit'
require 'active_support'
require 'htmlentities'
require "lib/util/imdb_metadata_scraper"
require "open-uri"

class ImdbMetadataScraperTvSeriesTest < Test::Unit::TestCase

  def test_search_for_imdb_id
    puts ""
    puts "Search 1"
    assert_equal('0411008', ImdbMetadataScraper.search_for_imdb_id('Lost', nil, true))
    puts "Search 2"
    assert_equal('0072567', ImdbMetadataScraper.search_for_imdb_id('starsky and hutch', 1975, true))
    puts "Search 3"
    #Search for tv show where a movie appears higher in the results
    assert_equal('0072567', ImdbMetadataScraper.search_for_imdb_id('starsky and hutch', nil, true))
  end

  def test_scrap_movie_info_lost
    puts "Scraping info"
    movie_info = ImdbMetadataScraper.scrap_movie_info('0411008')
    assert_equal('Lost', movie_info['title'])
    assert_equal('2004', movie_info['year'])
    assert_equal("The survivors of a plane crash are forced to live with each other on a remote island, a dangerous new world that poses unique threats of its own.", movie_info['plot'])
    assert_not_nil(movie_info['small_image'])
    assert_not_nil(movie_info['large_image'])
    
    assert_not_nil(movie_info['episodes'])
    assert !movie_info['episodes'].empty?
    series_2_ep_5 = nil
    movie_info['episodes'].each do |episode|
      assert_not_nil(episode['series'])
      assert_not_nil(episode['episode'])
      assert_not_nil(episode['title'])
      assert_not_nil(episode['date'])
      
      series_2_ep_5 = episode if episode['series'] == 2 && episode['episode'] == 5
    end
    puts "Ep Count: #{movie_info['episodes'].length}"
    
    assert_not_nil(series_2_ep_5)
    assert_equal('...And Found', series_2_ep_5['title'])
    assert_equal(%q{A desperate and growingly insane Michael sets off into the jungle by himself determined to find Walt, but discovers that he is not alone. Meanwhile, Sawyer and Jin are ordered by their captors, the tail crash survivors, to take them to their camp. But they are delayed when Jin and the hulking Mr. Eko are forced to go into the jungle to look for Michael before the dreaded "others" find him first. Back at the beach camp, Sun frantically searches for her missing wedding ring which triggers flashbacks to Sun and Jin's past showing how they met for the first time in early 1990s Seoul, when Jin was working as a doorman of a fancy hotel where Sun was staying at for a courtship engagement set up by her mother.}, series_2_ep_5['plot'])
    assert_equal(Date.new(y=2005,m=10,d=19), series_2_ep_5['date'])
    
  end

end