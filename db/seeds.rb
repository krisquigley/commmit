# frozen_string_literal: true

class SeedDatabase
  def self.call
    printf("\nSeeding database...\n")
    new.call
  end

  def call
    printf("\nCreating User\n")

    default_user = create_default_user

    printf("\nCreating Account\n")
    default_account = Account.find_or_create_by!(name: default_user.username,
                                                 subdomain: default_user.username,
                                                 account_type: 'personal',
                                                 owner_user_id: default_user.id)
    printf('.')

    ActsAsTenant.current_tenant = default_account

    printf("\nCreating Values\n")

    values = %w[Family Chore Health Finance Home].map do |name|
      create_value(name)
    end

    printf("\nCreating Stories\n")

    200.times do
      create_story(values)
    end

    printf("\nCreating Commmits\n")

    Range.new(Time.current.to_date - 21.days, Time.current.to_date - 1.day).each do |date|
      create_commmit(date, values)
    end

    printf("\nDone")
  end

  def booleans
    [true, false]
  end

  def create_default_user
    default_user = User.create!(
      name: Faker::Name.name,
      username: 'default',
      email: 'default@example.com',
      password: 'password',
      password_confirmation: 'password',
      confirmed_at: Time.now
    )
    printf('.')

    default_user
  end

  def create_story(values)
    repeatable = booleans.sample

    story = Story.create!(
      goal: "to #{Faker::Verb.base}",
      reason: "I can #{Faker::Verb.base}",
      repeatable: repeatable,
      automatically_add: repeatable ? booleans.sample : false,
      notes: Faker::Lorem.paragraphs,
      values: values.sample(Array(0..5).sample)
    )
    printf('.')

    story
  end

  def create_commmit(date, values)
    commmit_goal = create_story(values)

    commmit = Commmit.create!(
      end_date: date,
      goal_id: commmit_goal.id
    )

    stories = Story.where(completed_at: nil).sample(Array(0..10).sample)

    planned_stories = PlannedStory.create(stories.map { |story| { story_id: story.id } })
    commmit.planned_stories << planned_stories

    commmit.planned_stories.reload.sample(Array(0..10).sample).each { |planned_story| planned_story.update(completed_at: date) }

    commmit.reflection = Reflection.new(
      happiness: Array(0..5).sample,
      notes: Faker::Lorem.paragraphs
    )

    commmit.save!

    printf('.')

    commmit
  end

  def create_value(name)
    value = Value.create!(
      name: name
    )
    printf('.')
    value
  end
end

SeedDatabase.call
