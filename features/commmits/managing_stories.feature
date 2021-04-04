Feature: Managing Stories In a Commmit
  A user can create a Commmit which is a predefined length of time in which to focus on a set of stories.

  Users then assign stories that they want to complete within the specified time.

  Productivity is determined by averaging the number of stories completed over the course of a day.

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Adding a one-time story
    Given I already have a "Commmit"
    And a Story
    When I add a one-time Story
    Then I should be notified that my "Story" was "added"
    And the Story should appear in my Commmit
    But I should not be able to add the Story again

  Scenario: Adding a repeating story
    Given I already have a "Commmit"
    And a Repeatable Story
    When I add a repeatable story
    Then I should be notified that my "Story" was "added"
    And the Story should appear in my Commmit
    Then I should be able to add the Story again

  Scenario: Creating a story
    Given I already have a "Commmit"
    When I create a new story from my Commmit
    Then I should be notified that my "Story" was "created"
    And the Story should appear in my Commmit

  Scenario: Removing a planned story
    Given I already have a Commmit with 1 planned stories
    When I remove a planned story
    Then I should be notified that my "Story" was "removed"
    And it should not be listed under my commmit anymore

  Scenario: Editing a story
  #   Given I already have a "Commmit" with planned stories
  #   When I edit a planned story
  #   And update it with valid details
  #   Then it should be reflected in my Commmit
  #   And notify me

  Scenario: Adding multiple stories at a time
  #   Given already have a Commmit
  #   When add a story to it
  #   Then I should be able to add another immediately after
  #   And notify me

  Scenario: Marking a story as done
    Given I already have a Commmit with 1 planned stories
    When I mark the planned story as done
    Then I should be notified that my "Story" was "done"
    And the planned story and story should be marked as done 

  Scenario: Marking a story as not done
    Given I already have a Commmit with 1 completed planned stories
    When I mark the planned story as not done
    Then I should be notified that my "Story" was "not_done"
    And the planned story and story should not be marked as done 

  Scenario: Marking a repeatable story as done
    Given I already have a Commmit with 1 repeatable planned stories
    When I mark the planned story as done
    Then I should be notified that my "Story" was "done"
    And the planned story should be marked as done 
    But I can still add the repeatable Story again