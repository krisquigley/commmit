@javascript
Feature: Creating Commmits

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Creating a Commmit with valid data
    Given I have some stories
    When I create a Commmit and choose a goal
    And submit the form
    Then I should be notified that my "Commmit" was "created"
    And see the goal in my list of Commmits once I have created it

  Scenario: Creating a Commmit and Commmit goal on the fly
    When I create a Commmit and create a new goal
    Then I should be notified that my "Commmit" was "created"
    And see the goal in my list of Commmits once I have created it

  Scenario: Creating a Commmit and changing the Commmit goal
    Given I have some stories
    When I create a Commmit and choose a goal
    Then I should be able to change the goal before creating it
    And see the goal in my list of Commmits once I have created it

  Scenario: Creating a Commmit without choosing a goal
    When I create a new Commmit with invalid details
    Then I should be alerted that something is wrong

  Scenario: Creating a Commmit for today when one already exists
    Given I already have a Commmit for today
    And I have some stories
    When I create a Commmit with the name test and choose to start it today
    Then I should be notified that a Commmit already exists for today

  # It should automatically assume that I want to create a Commmit for tomorrow
  Scenario: Creating a Commmit when I have completed today's early
    Given I already have a Commmit for today
    And I have some stories
    When I create a Commmit and choose a goal
    And submit the form
    Then I should be notified that my "Commmit" was "created"

  Scenario: Creating a Commmit and automatically adding repeatable stories
    Given I already have 3 automatic repeatable stories
    When I create a Commmit and choose a repeatable goal
    And submit the form
    Then I should be notified that my "Commmit" was "created"
    And see the repeatable stories in my list of planned stories

  Scenario: Searching one-off stories by goal for my Commmit Goal
    Given I already have 10 repeatable stories
    And 10 one-off stories
    When I choose a Commmit Goal
    And I search for one-off stories by goal for my commmit goal
    Then I should only see one-off stories in my results

  Scenario: Searching repeatable stories by goal for my Commmit Goal
    Given I already have 10 repeatable stories
    And 10 one-off stories
    When I choose a Commmit Goal
    And I search for repeatable stories by goal for my commmit goal
    Then I should only see repeatable stories in my results
