# frozen_string_literal: true

# Create some users
puts 'Seeding database...'
default_user = User.create(
  name: Faker::Name.name,
  username: 'default',
  email: 'default@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now,
  github_user_id: Integer(Faker::Number.number(digits: 10)),
  source: JSON.parse(File
    .read("#{Rails.root}/spec/fixtures/files/new_user_payload.json"))['member'].to_json
)
printf('.')

default_account = Account.find_or_create_by(name: default_user.username,
                                            subdomain: default_user.username,
                                            account_type: 'personal',
                                            owner_user_id: default_user.id)
printf('.')

ActsAsTenant.current_tenant = default_account

users = User.all

team = Team.create(name: Faker::Name.name, users: users)
printf('.')

10.times do
  Ticket.create(title: Faker::Hipster.sentence,
                estimated_effort: Integer(Faker::Number.number(digits: 1)),
                repository_name: Faker::Hipster.word,
                number: Integer(Faker::Number.number(digits: 1)),
                state: 'open',
                github_user_ids: [],
                url: Faker::Internet.url,
                issue_id: Integer(Faker::Number.number(digits: 10)),
                source: '{}')
  printf('.')
end

[2, 3, 4, 5].each do |week_no|
  sprint = Sprint.create(name: Faker::Hipster.word,
                         start_date: Time.now.ago(week_no.week + 1),
                         end_date: Time.now.ago(week_no.week),
                         team: team)

  tickets = Ticket.all.sample(5)
  tickets.each do |t|
    sprint.sprint_tickets.create(t.attributes.except('id')
          .merge(closed_at: Time.now.ago(week_no.week + 1)))
    printf('.')
  end
  sprint.update(closed_at: Time.now.ago(week_no.week))
  sprint.team.users.each do |user|
    sprint.retrospectives.create(user: user,
                                 role_happiness: rand(1..5),
                                 team_happiness: rand(1..5),
                                 company_happiness: rand(1..5),
                                 feedback: Faker::Hipster.sentence,
                                 happiness_goal: Faker::Hipster.sentence)
    printf('.')
  end
end

puts 'Done'
