Feature: Registration

  Scenario: Creating an account with correct details
    When I sign up with correct details
    Then I should be redirected to the account page

  Scenario: Creating an account with missing details
    When I sign up with missing details
    Then I should be shown a missing details error

  Scenario: Creating an account with an incorrect username format
    When I sign up with an incorrect usename format
    Then I should be shown an incorrect username error

  Scenario: Creating an account when an account already exists with the same name / domain
    Given a user already exists with the same name or domain
    When I sign up with the same name
    Then I should be shown an account already exists error

