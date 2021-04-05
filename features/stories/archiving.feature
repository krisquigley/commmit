Feature: Archiving Stories

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Archiving a story
    Given I already have a "Story"
    When I archive my Story
    Then I should be notified that my "Story" was "archived"
    And I should no longer see my Story

  Scenario: Unarchiving a story