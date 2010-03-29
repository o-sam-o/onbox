Feature: Manage video_contents
  In order to manage content
  users
  wants to be able to edit and update VideoContent models
  
  Scenario: Register new Movie
    Given I am on the new video_content page
    When I fill in "Name" with "My Movie"
    And I fill in "Year" with "2010"
    And I select "Pending" from "State"
    And I select "Movie" from "Type"
    And I fill in "Imdb" with "000001"
    And I press "Save"
    Then I should see "My Movie"
    And I should see "2010"
    And I should see "000001"

  Scenario: Register new Tv Show
    Given I am on the new video_content page
    When I fill in "Name" with "My Tv Show"
    And I fill in "Year" with "2010"
    And I select "Pending" from "State"
    And I select "Tv Show" from "Type"
    And I fill in "Imdb" with "000002"
    And I press "Save"
    Then I should see "My Tv Show"
    And I should see "2010"
    And I should see "000002"

  Scenario: Delete video_content
    Given the following Movies:
      |name|year|state|imdb_id|
      |name 1|2001|processed|imdb_id 1|
      |name 2|2002|processed|imdb_id 2|
      |name 3|2003|processed|imdb_id 3|
      |name 4|2004|processed|imdb_id 4|
    When I delete the 3rd video_content
    Then I should not see "name 3" within "#modelTable"
