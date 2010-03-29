Feature: Manage media_folders
  In order to view video content
  on box user's
  want to configure media folders where the content is stored
  
  Scenario: Register new media_folder
    Given I am on the new media_folder page
    When I fill in "Location" with "location 1"
    And I uncheck "Scan"
    And I press "Save"
    Then I should see "location 1"
    And I should see "false"

  Scenario: Delete media_folder
    Given the following media_folders:
      |location|scan|
      |location 1|false|
      |location 2|true|
      |location 3|false|
      |location 4|true|
    When I delete the 3rd media_folder
    Then I should not see "location 3" within "#foldersTable"
