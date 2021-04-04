Feature: Commmits
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

  Scenario: Listing Commmits
    Given I already have some "Commmits"
    When I visit the "Commmits" page
    Then I should see my most recent Commmits

  Scenario: Listing a Commmit which starts in the future
    Given I already have a Commmit which starts tomorrow
    When I visit the "Commmits" page
    Then I should see that it starts tomorrow

  Scenario: Listing a Commmit which is in progress
    Given I already have a Commmit which is in progress
    When I visit the "Commmits" page
    Then I should see that it finishes today

  Scenario: Listing a Commmit which has finished
    Given I already have a Commmit which has finished
    When I visit the "Commmits" page
    Then I should see that it finished yesterday

  Scenario: No Commmits
    When I visit the "Commmits" page
    Then I should see a message to create a Commmit

  Scenario: Viewing a Commmit
    Given I have an unfinished Commmit with planned stories
    When I view the "Commmit"
    Then I can see my planned stories

  Scenario: Viewing a Commmit that has finished
    Given I have a finished Commmit with planned stories
    When I view the "Commmit"
    Then I should not be able to edit the Commmit
    But I can view my Reflection

  # Scenario: Updating a Commmit
  #   Given I already have a "Commmit"
  #   When I edit the "Commmit"
  #   And update the "Commmit" with valid details
  #   Then I should be notified that it was "updated"
  #   And I should see the updated details

  Scenario: Archiving a Commmit
    Given I already have a "Commmit"
    When I archive my Commmit
    Then I should be notified that my "Commmit" was "archived"
    And I should no longer see my Commmit

  # Scenario: Unarchiving a Commmit
  #   Given I already have an Archived Commmit
  #   When I unarchive the Commmit
  #   Then I should be notified that my "Commmit" was "unarchived"
  #   And I should be able to see the Commmit again
    
  Scenario: Accessing the currently active Commmit
    The logo / home button should take the user to their currently active Commmit.

    Given I already have a Commmit with planned stories
    When I click on the home logo
    Then I should be taken to my latest Commmit

  Scenario: Adding a one-time story
    Given I already have a "Commmit"
    And some Stories
    When I add a one-time Story
    Then the Story should appear in my Commmit
    And I should be notified that my "Story" was "added"
    But I should not be able to add the Story again

  # Scenario: Adding a repeating story
  #   Given I already have a "Commmit"
  #   When I add a repeatable story
  #   Then it should appear in my Commmit
  #   And notify me
  #   Then I should be able to add it again

  # Scenario: Creating a story
  #   Given I already have a "Commmit"
  #   When I create a new story
  #   Then it should be added to my Commmit as well
  #   And notify me

  # Scenario: Removing a planned story
  #   Given I already have a "Commmit" with planned stories
  #   When I remove a planned story
  #   Then it should not be listed under my commmit anymore
  #   And notify me

  # Scenario: Editing a story
  #   Given I already have a "Commmit" with planned stories
  #   When I edit a planned story
  #   And update it with valid details
  #   Then it should be reflected in my Commmit
  #   And notify me

  # Scenario: Adding multiple stories at a time
  #   Given already have a Commmit
  #   When add a story to it
  #   Then I should be able to add another immediately after
  #   And notify me

  # Scenario: Marking a story as done
  #   Given I already have a "Commmit" with planned stories
  #   When I mark a planned story as done
  #   Then the planned story and story should be marked as done 
  #   And notify me

  # Scenario: Marking a story as not done
  #   Given I already have a "Commmit" with a done planned story
  #   When I mark a planned story as not done
  #   Then the planned story and story should not be marked as done 
  #   And notify me

  # Scenario: Marking a significant step as done
  #   Given I already have a "Commmit" with a planned story and significant steps
  #   When I mark a significant step as done
  #   Then it should be shown as done
  #   And notify me

  # Scenario: Marking a significant step as not done
  #   Given I already have a "Commmit" with a planned story with a done significant step
  #   When I mark a significant step as not done
  #   Then it should be shown as not done
  #   And notify me

  # Scenario: Searching for Commmits
  #   Given I already have a list of Commmits
  #   When I search for a name of a Commmit
  #   Then I should see it in the results

  # Scenario: Loading more Commmits
  #   A user can load more commmits utilising geared pagination

  #   Given I already have a list of Commmits
  #   When I scroll to the bottom
  #   Then it should load more

  # Scenario: Accessing someone elses Commmit
  #   Given there are additional users
  #   When I visit another user's Commmits
  #   Then I should get a 404
