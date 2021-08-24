Feature: Viewing a Commmit
  A user can create a Commmit which is a predefined length of time in which to focus on a set of stories.

  Users then assign stories that they want to complete within the specified time.

  Productivity is determined by averaging the number of stories completed over the course of a day.

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Viewing a Commmit
    Given I have an unfinished Commmit with 5 planned stories
    When I view the "Commmit"
    Then I can see my planned stories

  Scenario: Viewing a Commmit with a Commmit Goal
    Given I have a Commmit with a Commmit Goal and 5 planned stories
    When I view the "Commmit"
    Then I should see my Commmit Goal at the top of the list
    And I cannot remove it

  Scenario: Viewing Todays Commmit with no active Commmit
    Given that I have no Commmits in progress
    When I click on Today
    Then I should be notified that I have no Commmits today

  Scenario: Viewing Todays Commmit with an active Commmit
    Given that I have a Commmit in progress
    When I click on Today
    Then I should be taken to the Commmit in progress

  Scenario: Viewing a Commmit that has been reflected
    Given I have a reflected Commmit with 5 planned stories
    When I view the "Commmit"
    Then I should not be able to edit the Commmit
    But I can view my Reflection

  Scenario: Accessing the currently active Commmit
    Given I already have a Commmit with 1 planned stories
    When I click on Today
    Then I should be taken to my latest Commmit

  @javascript
  Scenario: Searching one-off stories by goal to add to my Commmit
    Given that I have a Commmit in progress
    And I already have 5 repeatable stories
    And 10 one-off stories
    When I search for one-off stories by goal for my Commmit
    Then I should only see one-off stories in my results

  @javascript
  Scenario: Searching repeatable stories by goal to add to my Commmit
    Given that I have a Commmit in progress
    And I already have 5 repeatable stories
    And 10 one-off stories
    When I search for repeatable stories by goal for my Commmit
    Then I should only see repeatable stories in my results
