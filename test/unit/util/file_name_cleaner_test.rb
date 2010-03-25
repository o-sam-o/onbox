require 'test/unit'
require "lib/util/file_name_cleaner"

class FileNameCleanerTest < Test::Unit::TestCase
	def test_get_name_info		
	  content_test_helper('My Movie.avi', 'My Movie', 'My Movie', nil, nil, nil)
		content_test_helper('/test/My Movie.avi', 'My Movie', 'My Movie', nil, nil, nil)
		content_test_helper('/test/My Movie.2010.avi', 'My Movie 2010', 'My Movie', 2010, nil, nil)
		content_test_helper('/test/My-Movie.2010.avi', 'My Movie 2010', 'My Movie', 2010, nil, nil)
		content_test_helper('/test/My-Movie.DivX.avi', 'My Movie DivX', 'My Movie', nil, nil, nil)
		
		content_test_helper('/test/My-Tvshow.S12E01.avi', 'My Tvshow S12E01', 'My Tvshow', nil, 12, 1)
		content_test_helper('/test/My-Tvshow.S12 E01.avi', 'My Tvshow S12 E01', 'My Tvshow', nil, 12, 1)
		content_test_helper('/test/My-Tvshow.1x3.avi', 'My Tvshow 1x3', 'My Tvshow', nil, 1, 3)
		content_test_helper('/test/My-Tvshow.01x03.avi', 'My Tvshow 01x03', 'My Tvshow', nil, 1, 3)
		content_test_helper('/test/My-Tvshow.01x03.extra.avi', 'My Tvshow 01x03 extra', 'My Tvshow', nil, 1, 3)
		
    content_test_helper('/test/Fanboys (2008) LIMITED DVDRip XviD-SAPHiRE-NoRARs.avi', 
                        'Fanboys (2008) LIMITED DVDRip XviD SAPHiRE NoRARs', 
                        'Fanboys', 2008, nil, nil)
    content_test_helper('/test/Fanboys [2008] LIMITED DVDRip XviD-SAPHiRE-NoRARs.avi', 
                        'Fanboys [2008] LIMITED DVDRip XviD SAPHiRE NoRARs', 
                        'Fanboys', 2008, nil, nil) 
    content_test_helper('/test/Rendition[2007]DvDrip[Eng]-FXG.mkv', 
                        'Rendition[2007]DvDrip[Eng] FXG', 
                        'Rendition', 2007, nil, nil)                         
    content_test_helper('/test/High Fidelity(Xvid)(Darkside_RG).mp4', 
                        'High Fidelity(Xvid)(Darkside RG)', 
                        'High Fidelity', nil, nil, nil)  
    content_test_helper('/test/High Fidelity[Xvid](Darkside_RG).mp4', 
                        'High Fidelity[Xvid](Darkside RG)', 
                        'High Fidelity', nil, nil, nil)                        
    content_test_helper('/test/2012.(cam).avi', 
                        '2012 (cam)', 
                        '2012', nil, nil, nil)
    content_test_helper('/test/2012.(CAM).avi', 
                        '2012 (CAM)', 
                        '2012', nil, nil, nil)
    content_test_helper('/test/FlashForward.S01E01.720p.HDTV.x264-CTU.mkv', 
                        'FlashForward S01E01 720p HDTV x264 CTU', 
                        'FlashForward', nil, 1, 1)     
    content_test_helper('/test/FlashForward.S02e14.720p.HDTV.x264-CTU.mkv', 
                        'FlashForward S02e14 720p HDTV x264 CTU', 
                        'FlashForward', nil, 2, 14)
    content_test_helper('/test/Inglourious Basterds PPV XViD-IMAGiNE.nfo', 
                        'Inglourious Basterds PPV XViD IMAGiNE', 
                        'Inglourious Basterds', nil, nil, nil)  
    content_test_helper('/test/A History of Britain - 02 of 15 - Beginnings.avi', 
                        'A History of Britain   02 of 15   Beginnings', 
                        'A History of Britain', nil, 1, 2) 
    content_test_helper('/test/A History of Britain - 02of15 - Beginnings.avi', 
                        'A History of Britain   02of15   Beginnings', 
                        'A History of Britain', nil, 1, 2)                        
    content_test_helper('/test/Bee Movie [2007-DVDRip-H.264]-NewArtRiot.m4v', 
                        'Bee Movie [2007 DVDRip H 264] NewArtRiot', 
                        'Bee Movie', 2007, nil, nil)  
    content_test_helper('/test/Cypher [2002, Jeremy Northam, Lucy Liu, David Hewlett, Vincenzo Natali].avi  ', 
                        'Cypher [2002, Jeremy Northam, Lucy Liu, David Hewlett, Vincenzo Natali]', 
                        'Cypher', 2002, nil, nil)                                              
    
    # get 100% coverage                                 
    assert_equal 'Inglourious Basterds', FileNameCleaner.get_name_info('/test/Inglourious Basterds PPV XViD-IMAGiNE.nfo').to_s
    assert_equal 'raw name', FileNameInfo.new(:raw_name => 'raw name').to_s
    assert_equal 'location', FileNameInfo.new(:location => 'location').to_s
	end 
	
	def content_test_helper(location, raw_name, name, year, series, episode)
	  c = FileNameCleaner.get_name_info(location)
	  assert_not_nil(c)
		assert_equal(location, c.location)
		assert_equal(raw_name, c.raw_name)
		assert_equal(name, c.name)
		assert_equal(year, c.year)
		assert_equal(series, c.series)
		assert_equal(episode, c.episode)	  
	end
end