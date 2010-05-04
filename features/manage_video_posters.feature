Feature: Manage video_posters
  In order to select videos
  users
  wants see movie posters
  
  Scenario: Register new video_poster
    Given the following Movies:
      |name        |year |state     |imdb_id  |
      |movie name 1|2001 |processed |0000069  |
  	And I am logged in as "adminUser" 
    And I am on the "movie name 1" video_content page
    And I click "Edit Details"      
    And I click "Edit Posters"
    And I click "New Poster"
    When I fill in "Location" with "location 1"
    And I select "Large" from "Size"
    And I press "Save"
    Then I should see "location 1"
    And I should see "Large"

   Scenario: Register new video_poster
     Given the following Movies:
      |name   |year |state     |imdb_id  |
      |movie 1|2001 |processed |0000069  |  
     And the following video_posters:
      |location|size|video_content|
      |location 1|large|movie 1|
   	 And I am logged in as "adminUser" 
     And I am on the "movie 1" video_content page
     And I click "Edit Details"      
     And I click "Edit Posters"
     And I click "Edit"
     When I fill in "Location" with "updated location"
     And I press "Save"
     Then I should see "updated location"
     And I should see "Large"

  Scenario: Delete video_poster
    Given the following Movies:
      |name   |year |state     |imdb_id  |
      |movie 1|2001 |processed |0000069  |  
    And the following video_posters:
      |location|size|video_content|
      |location 1|small|movie 1|
      |location 2|large|movie 1|
      |location 3|small|movie 1|
      |location 4|large|movie 1|
  	And I am logged in as "adminUser"       
    When I delete the 3rd video_poster for "movie 1"
    Then I should not see "location 3" within "table"
    And I should see "location 1"
    And I should see "location 2"
    And I should see "location 4"
