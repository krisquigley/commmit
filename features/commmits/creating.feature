Feature: Creating Commmits
  A user can create a Commmit which is a predefined length of time in which to focus on a set of stories.

  Users then assign stories that they want to complete within the specified time.

  Productivity is determined by averaging the number of stories completed over the course of a day.

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Creating a Commmit with valid data
    When I create a Commmit with the name test
    Then I should be notified that my "Commmit" was "created"
    And see "Test" in my list of "Commmits"

  @javascript
  Scenario: Creating a Commmit without a name
    When I create a new Commmit with invalid details
    Then I should be alerted that something is wrong

  @javascript
  Scenario: Quickly changing the start date
    Given I am creating a Commmit
    When I click "Tomorrow"
    Then the date should match tomorrows date
    When I click "Today"
    Then the date should change back to today

  Scenario: Creating a Commmit and automatically adding repeatable stories
    Given I already have 3 automatic repeatable stories 
    When I create a Commmit with the name test
    Then I should be notified that my "Commmit" was "created"
    And see the repeatable stories in my list of planned stories
