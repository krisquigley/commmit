Feature: Creating Commmits

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Creating a Commmit with valid data
    Given I have a reflected Commmit
    When I create a Commmit with the name test
    Then I should be notified that my "Commmit" was "created"
    And see "Test" in my list of "Commmits"

  @javascript
  Scenario: Creating a Commmit without a name
    When I create a new Commmit with invalid details
    Then I should be alerted that something is wrong

  Scenario: Creating a Commmit when one already exists for today
    Given I already have a Commmit for today
    When I create a Commmit with the name test
    Then I should be notified that a Commmit already exists for today

  Scenario: Creating a Commmit and automatically adding repeatable stories
    Given I already have 3 automatic repeatable stories 
    When I create a Commmit with the name test
    Then I should be notified that my "Commmit" was "created"
    And see the repeatable stories in my list of planned stories
