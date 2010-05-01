Feature: Manage video_contents
  In order to manage content
  users
  wants to be able to edit and update VideoContent models

  Scenario: Register new Movie
	Given a user is logged in as "adminUser" 
    And I am on the new video_content page
    When I fill in "Name" with "My Title"
    And I fill in "Year" with "2010"
    And I select "Pending" from "State"
    And I select "Movie" from "Type"
    And I fill in "Imdb" with "000001"
    And I press "Save"
    Then I should see "My Title"
    And I should see "2010"
    And I should see "000001"
	And the video type should be "Movie"

  Scenario: Register new Tv Show
	Given a user is logged in as "adminUser"     
	And I am on the new video_content page
    When I fill in "Name" with "My Other Title"
    And I fill in "Year" with "2010"
    And I select "Pending" from "State"
    And I select "Tv Show" from "Type"
    And I fill in "Imdb" with "000002"
    And I press "Save"
    Then I should see "My Other Title"
    And I should see "2010"
    And I should see "000002"
	And the video type should be "Tv Show"

  Scenario: Update a movie
    Given the following Movies:
      |name        |year |state     |imdb_id  |
      |movie name 1|2001 |processed |0000069  |
	And I am logged in as "adminUser" 
    And I am on the "movie name 1" video_content page
    And I click "Edit Details"
    When I fill in "Name" with "New Movie Name"
    And I press "Save"
    Then I should see "New Movie Name"
    And I should see "2001"
    And I should see "0000069"

  Scenario: Update a tv show
    Given the following TvShows:
      |name        |year |state     |imdb_id  |
      |tv name 1   |2002 |processed |0000070  |
	And I am logged in as "adminUser" 
    And I am on the "tv name 1" video_content page
    And I click "Edit Details"
    When I fill in "Name" with "New Show Name"
    And I press "Save"
    Then I should see "New Show Name"
    And I should see "2002"
    And I should see "0000070"
    
    Scenario: Change a movie to a tv show
      Given the following Movies:
        |name        |year |state     |imdb_id  |
        |movie name 1|2001 |processed |0000069  |
  	  And I am logged in as "adminUser" 
      And I am on the "movie name 1" video_content page
      And I click "Edit Details"
      And I select "Tv Show" from "Type"
      And I press "Save"
      Then I should see "movie name 1"
      And I should see "2001"
      And I should see "0000069"
      And the video type should be "Tv Show"

  Scenario: Delete video_content
    Given the following Movies:
      |name|year|state|imdb_id|
      |name 1|2001|processed|imdb_id 1|
      |name 2|2002|processed|imdb_id 2|
      |name 3|2003|processed|imdb_id 3|
      |name 4|2004|processed|imdb_id 4|
	And a user is logged in as "adminUser"     
	When I delete the 3rd video_content
    Then I should not see "name 3" within "#modelTable"

  Scenario: Episode info displayed
    Given the following TvShows:
      |name|year|state|
      |Lost|2004|processed|
      |AnotherShow|2005|processed|
	And the following episodes:
	  |series|episode|title|tv_show|
	  |1|1|Pilot|Lost|
	  |1|2|Episode 2|Lost|
	  |2|1|S02 E01|Lost|
	  |1|1|ForAnotherShow|AnotherShow|
	And a user is logged in as "adminUser" 
	And I am on the "Lost" video_content page
	Then I should see "Pilot"
	And I should see "Episode 2"
	And I should see "S02 E01"
	And I should not see "ForAnotherShow"

  @culerity
  Scenario: If watched icon is clicked when a user is not logged in they should be redirects to the login page
    Given the following TvShows:
      |name  |year |imdb_id |state    |
      |Avatar|2009 |000007  |processed|
	Given I am on the "Avatar" video_content page
	When I click "watchedContentLink"
	Then I should be on the login page

  @culerity
  Scenario: Mark a video as watched
    Given the following TvShows:
      |name  |year |imdb_id |state    |
      |Avatar|2009 |000008  |processed|
	Given a user is logged in as "aUser" 
	And I am on the "Avatar" video_content page
	When I click "watchedContentLink"
	Then I should see "Watched"
	When I click "watchedContentLink"
	Then I should see "Click to mark as watched"

  @culerity	
  Scenario: Change imdb id
    Given the following TvShows:
      |name|year|imdb_id|state|
      |Lost|2004|000009|processed|	
    And the following video_file_references:
      |raw_name|location|on_disk|media_folder|video_content|
      |raw_name 1|LostS01E01.avi|true|media_folder 1|Lost|
	Given a user is logged in as "adminUser" 
	And I am on the "Lost" video_content page
    When I fill in "Imdb Id" with "999999"
	And I press "Change"
	Then I should see "Pending"
	And I should see "999999"
	And I should see "LostS01E01"

  @culerity	
  Scenario: Merge two different video contents
    Given the following media_folders:
      |location|scan|
      |media_folder 1|true|
    And the following TvShows:
      |name|year|imdb_id|state|
      |Lost|2004|000001|processed|	
      |Wrong Lost|2003|000002|processed|
    Given the following video_file_references:
      |raw_name|location|on_disk|media_folder|video_content|
      |raw_name 1|LostS01E01.avi|true|media_folder 1|Lost|
	  |raw_name 2|LostS01E02.avi|true|media_folder 1|Wrong Lost|
	And a user is logged in as "adminUser" 
	And I am on the "Wrong Lost" video_content page
    When I fill in "Imdb Id" with "000001"
	And I press "Change"
	Then I should see "000001"	
	And I should see "LostS01E01.avi"
	And I should see "LostS01E02.avi"
	And I am on the video_contents index page
	And I should not see "Wrong Lost"