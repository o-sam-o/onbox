Feature: On Box Home Page
  In order to pick a movie to watch
  users
  wants to view and search movies on the box

  Scenario: Simple view
    Given the following Movies:
      |name   |year |state     |
      |Avatar |2009 |processed |
      |Batman |2002 |processed |
    And the following TvShows:
      |name |year |state     |
      |Lost |2004 |processed |
	And I am on the home page
	Then I should see "Avatar"
	And I should see "Batman"
	And I should see "Lost"
	
  Scenario: Ajax load content
    Given the following Movies:
      |name      |year |state     | 
      |Zoolander |2005 |processed |
      |Avatar    |2009 |processed |
      |Batman    |2002 |processed |
    And the following TvShows:
      |name |year |state     |
      |Lost |2004 |processed |
	And I load the home page items with an offset of 2 and a page size of 2
	Then I should see "Lost"
	And I should see "Zoolander"
	And I should not see "Avatar"
	And I should not see "Batman"
 
  Scenario: View unwatched videos
	Given the following users:
      |login       |password   |password_confirmation |
      |aUser       |generic    |generic               |
      |anotherUser |password 2 |password 2            |
  	Given the following Movies:
      |name   |year |state     |
      |Avatar |2009 |processed |
      |Batman |2002 |processed |
    And the following TvShows:
      |name       |year |state     |
      |Lost       |2004 |processed |
      |Underbelly |2010 |processed |
	And the following watches:
	  |video_content |user        |
	  |Avatar        |aUser       |
	  |Underbelly    |aUser       |
	  |Batman        |anotherUser | 
	And I am logged in as "aUser"   	 
	And I am on the "unwatched" home page
	Then I should see "Lost"
	And I should see "Batman"
	And I should not see "Avatar"
	And I should not see "Underbelly"
  
  Scenario: View videos by genre
  	Given the following Movies:
      |name   |year |state     | genres   |
      |Avatar |2009 |processed | Action   |
      |Batman |2002 |processed | Aventure |
    And the following TvShows:
      |name       |year |state     | genres  |
      |Lost       |2004 |processed | Drama   |
      |Underbelly |2010 |processed | Action  |
	And I am on the "action" home page
	Then I should see "Avatar"
	And I should see "Underbelly"
	And I should not see "Batman"
	And I should not see "Lost"	

    Scenario: View videos by sci-fi genre
     Given the following Movies:
      |name   |year |state     | genres   |
      |Avatar |2009 |processed | Sci-Fi   |
      |Batman |2002 |processed | Aventure |
     And the following TvShows:
      |name       |year |state     | genres  |
      |Lost       |2004 |processed | Drama   |
      |Underbelly |2010 |processed | Action  |
  	 And I am on the "sci-fi" home page
  	 Then I should see "Avatar"
  	 And I should not see "Underbelly"
  	 And I should not see "Batman"
  	 And I should not see "Lost"
	
  Scenario: View unwatched for a specific genre videos
  	Given the following Movies:
      |name   |year |state     | genres |
      |Avatar |2009 |processed | Action |
      |Batman |2002 |processed | Drama  |
    And the following TvShows:
      |name       |year |state     | genres |
      |Lost       |2004 |processed | Action |
      |Underbelly |2010 |processed | Drama  |
	And I am logged in as "aUser"   
	And the following watches:
	  |video_content |user        |
	  |Avatar        |aUser       |
	  |Underbelly    |aUser       |
	And I am on the "unwatched, action" home page
	Then I should see "Lost"
	And I should not see "Batman"
	And I should not see "Avatar"
	And I should not see "Underbelly"	

  Scenario: Video search
  	Given the following Movies:
      |name    |year |state     | genres   |
      |Avatar  |2009 |processed | Action   |
      |Aviator |2004 |processed | Action   |
      |Batman  |2002 |processed | Aventure |
    And the following TvShows:
      |name       |year |state     | genres  |
      |Lost       |2004 |processed | Drama   |
      |Underbelly |2010 |processed | Action  |
  	And I am on the home page
  	When I fill in "Search All" with "Av"
  	And I press "Search"
  	And I should see "Avatar"
	And I should see "Aviator"
  	And I should not see "Batman"
  	And I should not see "Underbelly"
  	And I should not see "Lost"	

  Scenario: Video search exact match
  	Given the following Movies:
      |name    |year |state     | genres   |
      |Avatar  |2009 |processed | Action   |
      |Aviator |2004 |processed | Action   |
      |Batman  |2002 |processed | Aventure |
    And the following TvShows:
      |name       |year |state     | genres  |
      |Lost       |2004 |processed | Drama   |
      |Underbelly |2010 |processed | Action  |
  	And I am on the home page
  	When I fill in "Search All" with "Avatar"
  	And I press "Search"
  	And I should see "Avatar"
	And I should be on the "Avatar" video_content page
  
  Scenario: Video order
  	Given the following Movies:
      |name    |year |state     | genres   | created_at 		  |
      |Aviator |2004 |processed | Action   | 2010-03-04T21:39:32Z |
      |Batman  |2002 |processed | Aventure | 2010-03-05T21:39:32Z |
      |Avatar  |2009 |processed | Action   | 2009-03-06T21:39:32Z |
    And the following TvShows:
      |name       |year |state     | genres  | created_at |
      |Lost       |2004 |processed | Drama   | 2010-03-01T21:39:32Z |
      |Underbelly |2010 |processed | Action  | 2010-10-01T21:39:32Z |
  	And I am on the home page
  	And I order by "Name"
  	And I should see "Avatar" as the 1st video
	And I should see "Aviator" as the 2nd video
  	And I should see "Underbelly" as the 5th video
	And I order by "Added"
  	And I should see "Avatar" as the 5th video
	And I should see "Aviator" as the 3nd video
  	And I should see "Underbelly" as the 1st video	