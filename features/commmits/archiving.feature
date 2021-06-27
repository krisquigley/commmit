Feature: Archiving Commmits
  A user can create a Commmit which is a predefined length of time in which to focus on a set of stories.

  Users then assign stories that they want to complete within the specified time.

  Productivity is determined by averaging the number of stories completed over the course of a day.

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Archiving a Commmit
    Given I already have a "Commmit"
    When I archive my Commmit
    Then I should be notified that my "Commmit" was "archived"
    And I should no longer see my Commmit

  Scenario: Unarchiving a Commmit
    Given I already have an Archived Commmit
    When I visit archived Commmits
    And I unarchive the Commmit
    Then I should be notified that my "Commmit" was "unarchived"
    And I should be able to see the Commmit again

  Scenario: Unarchiving a Commmit when one exists for that day
    Given I already have an Archived Commmit
    And a Commmit on that day
    When I visit archived Commmits
    And I unarchive the Commmit
    Then I should be notified that my "Commmit" was "unable_to_unarchive"
    And my Commmit should still be listed