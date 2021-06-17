Feature: Sessions

  Scenario: Logging in with correct details
    Given a "default" user
    When I log in with correct details
    Then I should be redirected to the account page

  Scenario: Logging in with incorrect details
    Given a "default" user
    When I log in with incorrect details
    Then I should be shown an invalid email error

  Scenario: Logging out
    Given a "default" user
    And already logged in
    When I log out
    Then I should be redirected to the landing page

