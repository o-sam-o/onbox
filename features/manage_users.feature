Feature: Manage users
  In order to control access
  an admin user
  wants to be able administer other users
  
  Scenario: Register new user
	Given a user is logged in as "adminUser"
    And I am on the new user page
    When I fill in "Login" with "login 1"
    And I fill in "Password" with "password 1"
    And I fill in "Password Again" with "password 1"
    And I press "Save"
    Then I should see "login 1"


  Scenario: Delete user
	Given a user is logged in as "adminUser"    
	And the following users:
      |login|password|password_confirmation|
      |login 1|password 1|password 1|
      |login 2|password 2|password 2|
      |login 3|password 3|password 3|
      |login 4|password 4|password 4|
    When I delete the 3rd user
    Then I should see "login 1" within "#usersTable"
	And I should see "login 2" within "#usersTable"
	And I should see "login 4" within "#usersTable"
	And I should not see "login 3" within "#usersTable"
