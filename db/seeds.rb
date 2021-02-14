# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create some users

ActiveRecord::Base.transaction do
  tenant = Account.create(name: 'default', subdomain: 'default')
  ActsAsTenant.current_tenant = tenant
  
  2.times do 
    User.create(name: Faker::Name.name, 
                github_user_id: Integer(Faker::Number.number(digits: 10)), 
                source: JSON.parse(File.read("#{Rails.root.to_s}/spec/fixtures/files/new_user_payload.json"))["member"].to_json)
  end
  users = User.all

  team = Team.create(name: Faker::Name.name, users: users)

  10.times do 
    Ticket.create(title: Faker::Hipster.sentence,
                  estimated_effort: Integer(Faker::Number.number(digits: 1)),
                  repository_name: Faker::Hipster.word,
                  number: Integer(Faker::Number.number(digits: 1)),
                  state: 'open',
                  github_user_ids: [],
                  url: Faker::Internet.url,
                  issue_id: Integer(Faker::Number.number(digits: 10)),
                  source: "{}")
  end

  [2, 3, 4, 5].each do |week_no|
    sprint = Sprint.create(name: Faker::Hipster.word,
                          start_date: Time.now.ago(week_no.week + 1),
                          end_date: Time.now.ago(week_no.week),
                          team: team)

    tickets = Ticket.all.sample(5)
    tickets.each do |t| 
      sprint.sprint_tickets.create(t.attributes.except("id")
            .merge(closed_at: Time.now.ago(week_no.week + 1)))
    end
    sprint.update(closed_at: Time.now.ago(week_no.week))
    sprint.team.users.each do |user|
      sprint.retrospectives.create(user: user, 
                                   role_happiness: rand(5) + 1, 
                                   team_happiness: rand(5) + 1,
                                   company_happiness: rand(5) + 1, 
                                   feedback: Faker::Hipster.sentence,
                                   happiness_goal: Faker::Hipster.sentence)
    end
  end
end