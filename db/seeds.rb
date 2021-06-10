# frozen_string_literal: true

printf("\nSeeding database...\n")
ActiveRecord::Base.transaction do
  printf("\nCreating User\n")
  default_user = User.create!(
    name: Faker::Name.name,
    username: 'default',
    email: 'default@example.com',
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.now,
  )
  printf('.')

  printf("\nCreating Account\n")
  default_account = Account.find_or_create_by!(name: default_user.username,
                                              subdomain: default_user.username,
                                              account_type: 'personal',
                                              owner_user_id: default_user.id)
  printf('.')

  ActsAsTenant.current_tenant = default_account

  printf("\nCreating Values\n")

  values = %w[Family Chore Health Finance Home].map do |name|
    value = Value.create!(
      name: name
    )
    printf('.')
    value
  end

  printf("\nCreating Stories\n")

  booleans = [true, false]

  stories = 200.times do
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

  printf("\nCreating Commmits\n")

  Range.new(Time.current.to_date - 21.days, Time.current.to_date - 1.day).each do |date|
    commmit = Commmit.create!(
      name: Faker::Fantasy::Tolkien.poem,
      end_date: date
    )

    stories = Story.where(completed_at: nil).sample(Array(0..10).sample)

    planned_stories = PlannedStory.create(stories.map { |story| { story_id: story.id } })
    commmit.planned_stories = planned_stories

    planned_stories.sample(Array(0..10).sample).each { |planned_story| planned_story.update(completed_at: date) }

    commmit.reflection = Reflection.new(
      happiness: Array(0..5).sample,
      goal_met: booleans.sample,
      notes: Faker::Lorem.paragraphs
    )

    commmit.save!

    printf('.')
  end
end

printf("\nDone")
