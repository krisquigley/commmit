Feature: Reflections

  At the end of a commmit the user is prompted to reflect on how their Commmit went.

  Background: 
    Given a "default" user
    And already logged in

  Scenario: Prompting the user to reflection
    Given I have an elapsed Commmit
    When I try to create a new Commmit
    Then I should be prompted to reflect

  Scenario: Showing the user what they did and didn't achieve
    Given I have an elapsed Commmit
    When I reflect on the Commmit
    Then I should be shown what I have and haven't completed

  Scenario: Showing scientifically proven tips on how to improve productivity

  Scenario: Showing tips on how to use the app more effectively

  Scenario: Showing the user a message based on their performance

  Scenario: Notifying the user of barriers encountered

    Users will be displayed 3 of the most common barriers faced during the commmit and will be encouraged to create stories to work towards removing them.

  Scenario: Recording notes
    Given I have an elapsed Commmit
    When I reflect on the Commmit
    Then I should be able to add notes

  Scenario: Recording the user's happiness
    Given I have an elapsed Commmit
    When I reflect on the Commmit
    Then record my happiness

  Scenario: Viewing previous reflections
    Given I have a reflected Commmit
    When I view the Commmit
    Then I should be able to view the completed reflection

