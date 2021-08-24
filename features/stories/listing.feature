@javascript
Feature: Listing Stories

  Background: 
    Given a "default" user
    And already logged in
    
  Scenario: Listing one-off stories
    Given I already have a one-off story
    When I visit the "Stories" page
    Then I should see my one-off Story under the Once tab

  Scenario: Loading more stories
    Given I already have 20 stories
    When I visit the "Stories" page
    Then I should see my one-off Story under the Once tab
    And I should be able to load more stories

  Scenario: Listing repeatable stories
    Given I already have a repeatable story
    When I visit the "Stories" page
    Then I should see my repeatable Story under the Repeatable tab

  Scenario: Loading more repeatable stories
    Given I already have 20 repeatable stories
    When I visit the "Stories" page
    Then I should see my repeatable Story under the Repeatable tab
    And I should be able to load more stories

  Scenario: Viewing the order of repeatable stories
    Given I already have 5 repeatable stories
    When I have completed some stories
    Then I should see the non-completed newest stories first
    And I should see the most recent completed stories afterwards

  Scenario: Searching one-off stories by goal
    Given I already have 5 repeatable stories
    And 5 one-off stories
    When I search for one-off stories by goal
    Then I should only see one-off stories in my results

  Scenario: Searching one-off stories by reason
    Given I already have 5 repeatable stories
    And 5 one-off stories
    When I search for one-off stories by reason
    Then I should only see one-off stories in my results

  Scenario: Searching one-off stories by value
    Given I already have 5 repeatable stories
    And 5 one-off stories
    When I search for one-off stories by value
    Then I should only see one-off stories in my results

  Scenario: Searching repeatable stories by goal
    Given I already have 5 repeatable stories
    And 5 one-off stories
    When I search for repeatable stories by goal
    Then I should only see repeatable stories in my results