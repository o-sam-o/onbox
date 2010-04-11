Feature: Bulk update a number of different video contents
  In order to correct scraping errors
  admin users
  wants to be able easily change a whole heap of video contents

  Scenario: Update the imdb id of two video contents at the same time
    Given the following media_folders:
      |location      |scan|
      |media_folder 1|true|
    And the following TvShows:
      |name        |year|imdb_id|state    |
      |Wrong Lost 1|2004|000001 |processed|	
      |Wrong Lost 2|2003|000002 |processed|
    Given the following video_file_references:
      |raw_name  |location      |on_disk|media_folder  |video_content|
      |raw_name 1|LostS01E01.avi|true   |media_folder 1|Wrong Lost 1|
	  |raw_name 2|LostS01E02.avi|true   |media_folder 1|Wrong Lost 2|
	And I am on the bulk video_content change page
    When I fill in "Search" with "Lost"
	And I press "Search"
	And I should see "Wrong Lost 1"
	And I should see "Wrong Lost 2"
	And I select the bulk change checkbox for "Wrong Lost 1"
	And I select the bulk change checkbox for "Wrong Lost 2"
	And I press "Next"
	And I fill in "Imdb Id" with "000003"
	And I press "Bulk Update"
	Then I should see "000003"	
	And I should see "LostS01E01.avi"
	And I should see "LostS01E02.avi"
	And I should see "Pending"