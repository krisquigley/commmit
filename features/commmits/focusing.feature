Feature: Focusing on a Planned Story
  A user can focus on a particular story in order to not be distracted by other tasks.

  Users can also choose to time the task and record it

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Focusing on a planned story
    Given I already have a Commmit with 1 planned stories
    When I click on the planned story
    Then I should be in focus mode

  Scenario: When focussed
    Given I am focussed on a planned story
    Then I should be able to see the notes
    And mark the story as done

  Scenario: When a Planned Story has already been done