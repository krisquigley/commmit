Feature: Listing Commmits

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Listing Commmits
    Given I already have some Commmits
    When I visit the "Commmits" page
    Then I should see my most recent Commmits

  Scenario: Listing a Commmit which is in progress
    Given I already have a Commmit which is in progress
    When I visit the "Commmits" page
    Then I should see that it finishes today

  Scenario: Listing a Commmit which has finished
    Given I already have a Commmit which has finished
    When I visit the "Commmits" page
    Then I should see that it finished yesterday

  @javascript
  Scenario: No Commmits
    When I visit the "Commmits" page
    Then I should see a message to create a Commmit

  Scenario: Searching for Commmits
  #   Given I already have a list of Commmits
  #   When I search for a name of a Commmit
  #   Then I should see it in the results

  Scenario: Loading more Commmits
    A user can load more commmits utilising geared pagination

  # Given I already have a list of Commmits
  #   When I scroll to the bottom
  #   Then it should load more