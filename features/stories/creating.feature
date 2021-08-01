@javascript
Feature: Creating Stories

  A story is a paragraph of text which records a goal to be achieved and it's reason for achieving it.

  Stories can be one-off tasks or repeatable actions, such as chores.

  Stories can be assigned values in order to help organisation and focus tracking.

  Meatier stories can be planned through the use of recording the significant steps needed to be done to complete the story.

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Creating a story with valid values
    The user should be taken back to the create story page so that they can quickly add multiple stories.
    
    When I create a Story with the goal of "to tame my inner b*tch"
    Then I should be notified that my "Story" was "created"
    And I should be able presented with an empty Story form

  @javascript
  Scenario: Creating a story without a goal
    When I create a new Story with invalid details
    Then I should be alerted that something is missing

  Scenario: Creating a one-time Story
    One time stories are goal which are typically only ever done once

    When I create a one-time Story
    Then my Story should have no repeat icon

  Scenario: Creating a repeatable Story
    Repeatable Stories can be completed over and over again, and are typically used for chores or building habits.

    When I create a repeatable Story
    Then my Story should have a repeat icon

  @javascript
  Scenario: Creating a repeatable story which gets automatically added

    Given I am creating a repeatable Story
    When I choose to make the Story get automatically added
    Then I should see a cog icon next to it

  Scenario: Valueing a story

