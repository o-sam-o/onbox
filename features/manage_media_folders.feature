Feature: Manage media_folders
  In order to view video content
  on box user's
  want to configure media folders where the content is stored
  
  Scenario: Register new media_folder
	Given a user is logged in as "adminUser" 
    And I am on the new media_folder page
    When I fill in "Location" with "location 1"
    And I uncheck "Scan"
    And I press "Save"
    Then I should see "location 1"
    And I should see "false"

  Scenario: Delete media_folder
	Given a user is logged in as "adminUser" 
    And the following media_folders:
      |location|scan|
      |location 1|false|
      |location 2|true|
      |location 3|false|
      |location 4|true|
    When I delete the 3rd media_folder
    Then I should not see "location 3" within "#foldersTable"

  Scenario: Edit media_folder
	Given a user is logged in as "adminUser" 
    And the following media_folders:
      |location|scan|
      |location 1|true|
    And I am on the media_folders page
	When I edit the 1st media_folder
	And I fill in "Location" with "updated location"
	And I press "Save"
	Then I should see "updated location"