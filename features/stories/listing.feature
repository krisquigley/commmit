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
    Given I already have 50 stories
    When I visit the "Stories" page
    Then I should see my one-off Story under the Once tab
    And I should be able to load more stories

  Scenario: Listing repeatable stories
    Given I already have a repeatable story
    When I visit the "Stories" page
    Then I should see my repeatable Story under the Repeatable tab

  Scenario: Loading more repeatable stories
    Given I already have 50 repeatable stories
    When I visit the "Stories" page
    Then I should see my repeatable Story under the Repeatable tab
    And I should be able to load more stories

  Scenario: Viewing the order of repeatable stories
    Given I already have 10 repeatable stories
    When I have completed some stories
    Then I should see the non-completed newest stories first
    And I should see the most recent completed stories afterwards

  Scenario: Searching for stories

    A user can search for a story by goal, reason, value, or notes.