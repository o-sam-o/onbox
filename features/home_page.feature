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
	

  Scenario: Ajax load content
    Given the following Movies:
      |name|year|state|
      |Zoolander|2005|processed|
      |Avatar|2009|processed|
      |Batman|2002|processed|
    And the following TvShows:
      |name|year|state|
      |Lost|2004|processed|
	And I load the home page items with an offset of 2 and a page size of 2
	Then I should see "Lost"
	And I should see "Zoolander"
	And I should not see "Avatar"
	And I should not see "Batman"