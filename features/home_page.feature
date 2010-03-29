Feature: On Box Home Page
  In order to pick a movie to watch
  users
  wants to view and search movies on the box

  Scenario: Simple view
    Given the following Movies:
      |name|year|state|
      |Avatar|2009|processed|
      |Batman|2002|processed|
    And the following TvShows:
      |name|year|state|
      |Lost|2004|processed|
	And I am on the home page
	Then I should see "Avatar"
	And I should see "Batman"
	And I should see "Lost"