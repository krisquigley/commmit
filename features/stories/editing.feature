@javascript
Feature: Editing Stories

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Updating a story with valid values
    Given I already have a "Story"
    When I edit the Story's goal
    Then will see the changes to my Story
