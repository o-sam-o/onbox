Feature: Manage video_file_references
  In order to know whats on the box
  a user
  wants to the see the media files on that box
  
  Scenario: Register new video_file_reference
    Given the following media_folders:
      |location|scan|
      |media_folder 1|true|
    And I am on the new video_file_reference page
    When I fill in "Raw name" with "raw_name 1"
    And I fill in "Location" with "location 1"
    And I check "On disk"
    And I select "media_folder 1" from "Media folder"
    And I press "Save"
    Then I should see "raw_name 1"
    And I should see "media_folder 1"

  Scenario: Delete video_file_reference
    Given the following video_file_references:
      |raw_name|location|on_disk|media_folder|
      |raw_name 1|location 1|false|media_folder 1|
      |raw_name 2|location 2|true|media_folder 2|
      |raw_name 3|location 3|false|media_folder 3|
      |raw_name 4|location 4|true|media_folder 4|
    When I delete the 3rd video_file_reference
    Then I should not see "raw_name 3" within "#referenceTable"
