require 'test/unit'
require "lib/util/file_name_cleaner"

class FileNameCleanerTest < Test::Unit::TestCase
  
	should 'correctly extract movie name and other info from the file name' do
	  content_test_helper('My Movie.avi', 'My Movie', 'My Movie')
		content_test_helper('/test/My Movie.avi', 'My Movie', 'My Movie')
		content_test_helper('/test/Ajami.avi', 'Ajami', 'Ajami')

		content_test_helper('/test/My Movie.2010.avi', 'My Movie 2010', 'My Movie', 2010)
		content_test_helper('/test/My-Movie.2010.avi', 'My Movie 2010', 'My Movie', 2010)
		content_test_helper('/test/My-Movie.DivX.avi', 'My Movie DivX', 'My Movie')
		
		content_test_helper('/test/My-Tvshow.S12E01.avi', 'My Tvshow S12E01', 'My Tvshow', nil, 12, 1)
		content_test_helper('/test/My-Tvshow.S12 E01.avi', 'My Tvshow S12 E01', 'My Tvshow', nil, 12, 1)
		content_test_helper('/test/My-Tvshow.1x3.avi', 'My Tvshow 1x3', 'My Tvshow', nil, 1, 3)
		content_test_helper('/test/My-Tvshow.01x03.avi', 'My Tvshow 01x03', 'My Tvshow', nil, 1, 3)
		content_test_helper('/test/My-Tvshow.01x03.extra.avi', 'My Tvshow 01x03 extra', 'My Tvshow', nil, 1, 3)
		content_test_helper('/test/1/The Universe - Season 1 Episode 12.avi', 'The Universe   Season 1 Episode 12', 'The Universe', nil, 1, 12)
		
		
    content_test_helper('/test/Fanboys (2008) LIMITED DVDRip XviD-SAPHiRE-NoRARs.avi', 
                        'Fanboys (2008) LIMITED DVDRip XviD SAPHiRE NoRARs', 
                        'Fanboys', 2008)
    content_test_helper('/test/Fanboys [2008] LIMITED DVDRip XviD-SAPHiRE-NoRARs.avi', 
                        'Fanboys [2008] LIMITED DVDRip XviD SAPHiRE NoRARs', 
                        'Fanboys', 2008) 
    content_test_helper('/test/Rendition[2007]DvDrip[Eng]-FXG.mkv', 
                        'Rendition[2007]DvDrip[Eng] FXG', 
                        'Rendition', 2007)
                                                 
    content_test_helper('/test/High Fidelity(Xvid)(Darkside_RG).mp4', 
                        'High Fidelity(Xvid)(Darkside RG)', 
                        'High Fidelity')  
    content_test_helper('/test/High Fidelity[Xvid](Darkside_RG).mp4', 
                        'High Fidelity[Xvid](Darkside RG)', 
                        'High Fidelity')                        
    content_test_helper('/test/2012.(cam).avi', 
                        '2012 (cam)', 
                        '2012')
    content_test_helper('/test/2012.(CAM).avi', 
                        '2012 (CAM)', 
                        '2012')
    content_test_helper('/test/FlashForward.S01E01.720p.HDTV.x264-CTU.mkv', 
                        'FlashForward S01E01 720p HDTV x264 CTU', 
                        'FlashForward', nil, 1, 1)     
    content_test_helper('/test/FlashForward.S02e14.720p.HDTV.x264-CTU.mkv', 
                        'FlashForward S02e14 720p HDTV x264 CTU', 
                        'FlashForward', nil, 2, 14)
    content_test_helper('/test/Inglourious Basterds PPV XViD-IMAGiNE.nfo', 
                        'Inglourious Basterds PPV XViD IMAGiNE', 
                        'Inglourious Basterds')  
    content_test_helper('/test/A History of Britain - 02 of 15 - Beginnings.avi', 
                        'A History of Britain   02 of 15   Beginnings', 
                        'A History of Britain', nil, 1, 2) 
    content_test_helper('/test/A History of Britain - 02of15 - Beginnings.avi', 
                        'A History of Britain   02of15   Beginnings', 
                        'A History of Britain', nil, 1, 2)                        
    content_test_helper('/test/Bee Movie [2007-DVDRip-H.264]-NewArtRiot.m4v', 
                        'Bee Movie [2007 DVDRip H 264] NewArtRiot', 
                        'Bee Movie', 2007)  
    content_test_helper('/test/Cypher [2002, Jeremy Northam, Lucy Liu, David Hewlett, Vincenzo Natali].avi  ', 
                        'Cypher [2002, Jeremy Northam, Lucy Liu, David Hewlett, Vincenzo Natali]', 
                        'Cypher', 2002)   
                        
    content_test_helper('/test/Angels & Demons (2009) DVDRip XviD-MAXSPEED/Angels & Demons (2009) DVDRip XviD-MAXSPEED www.torentz.3xforum.ro.avi',                                           
                        'Angels & Demons (2009) DVDRip XviD MAXSPEED www torentz 3xforum ro',
                        'Angels & Demons', 2009)
  end
  
  should 'correctly convert FileNameInfo to a string' do
    # get 100% coverage                                 
    assert_equal 'Inglourious Basterds', FileNameCleaner.get_name_info('/test/Inglourious Basterds PPV XViD-IMAGiNE.nfo').to_s
    assert_equal 'raw name', FileNameInfo.new(:raw_name => 'raw name').to_s
    assert_equal 'location', FileNameInfo.new(:location => 'location').to_s
	end 
	
	should 'remove number from movie name if there is more than one file for the same movie' do
	  #Valid case for number at end of name
	  content_test_helper('/test/District 9.avi', 'District 9', 'District 9')
	  
	  content_test_helper('/test/xscr-invictus_part1[dupedb.com].avi', 'xscr invictus part1[dupedb com]', 'xscr invictus part1[dupedb com]')
	  content_test_helper('/test/CD1/xscr-invictus_part1[dupedb.com].avi', 'xscr invictus part1[dupedb com]', 'xscr invictus')
	  content_test_helper('/test/CD1/xscr-invictus_Part1[dupedb.com].avi', 'xscr invictus Part1[dupedb com]', 'xscr invictus')
	  content_test_helper('/test/CD1/xscr-invictus_part 1[dupedb.com].avi', 'xscr invictus part 1[dupedb com]', 'xscr invictus')
	  
	  content_test_helper('/test/CD1/District 9-1.avi', 'District 9 1', 'District 9')
	  content_test_helper('/test/CD2/District 9-2.avi', 'District 9 2', 'District 9')
	  
	  content_test_helper('/test/CD1/dmt-intheloop1.avi', 'dmt intheloop1', 'dmt intheloop')
	  
	end
	
	should 'use folder name if media name is shortened' do
	  content_test_helper('/test/Fifty.Dead.Men.Walking.2008.DVDRIP.XviD-ZEKTORM/FDMW-ZEKTORM.avi', 
	                      'Fifty Dead Men Walking 2008 DVDRIP XviD ZEKTORM', 'Fifty Dead Men Walking', 2008)
	  content_test_helper('/test/In.The.Loop.DVDRip.XviD-DMT/CD1/dmt-intheloop1.avi', 'In The Loop DVDRip XviD DMT', 'In The Loop')
	end  
	
	should 'strip LIMITED from movie name' do
	  content_test_helper('/test/Bunny.And.The.Bull.LIMITED.DVDRip.XviD-DMT/dmt-bunnybull.avi', 
	                      'Bunny And The Bull LIMITED DVDRip XviD DMT', 'Bunny And The Bull')
	  content_test_helper('/test/The.Darjeeling.Limited.2007.DVDRip.AC3.iNT-DEViSE.avi', 'The Darjeeling Limited 2007 DVDRip AC3 iNT DEViSE', 
	                      'The Darjeeling Limited', 2007)	  
	  content_test_helper('/test/The.Lost.Boys[1987]DVDRip-tots/The.Lost.Boys[1987]DVDRip-tots.avi',
                        'The Lost Boys[1987]DVDRip tots', 
                        'The Lost Boys', 1987)
	end
	
	should 'find parent folder  of a media file' do
	  assert_nil FileNameCleaner.parent_folder_name('test.mpg')
	  assert_nil FileNameCleaner.parent_folder_name('/test.mpg')
	  assert_equal 'tmp', FileNameCleaner.parent_folder_name('/tmp/test.mpg')
	  assert_equal 'tmp', FileNameCleaner.parent_folder_name('/asdf/asdf/a/tmp/test.mpg')
	  assert_equal 'tmp', FileNameCleaner.parent_folder_name('tmp/test.mpg')
	  
	  assert_equal 'CD1', FileNameCleaner.parent_folder_name('/CD1/test.mpg')
	  assert_equal 'tmp', FileNameCleaner.parent_folder_name('/tmp/CD1/test.mpg')
	  assert_equal 'tmp', FileNameCleaner.parent_folder_name('/tmp/cd2/test.mpg')
	end  
	
	def content_test_helper(location, raw_name, name, year=nil, series=nil, episode=nil)
	  c = FileNameCleaner.get_name_info(location)
	  assert_not_nil(c)
		assert_equal(location, c.location)
		assert_equal(raw_name, c.raw_name)
		assert_equal(name, c.name, "For #{raw_name}")
		assert_equal(year, c.year, "For #{raw_name}")
		assert_equal(series, c.series, "For #{raw_name}")
		assert_equal(episode, c.episode, "For #{raw_name}")	  
	end
end