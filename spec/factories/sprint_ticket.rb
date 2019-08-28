FactoryBot.define do
  factory :sprint_ticket do
    title { Faker::Hipster.sentence }
    estimated_effort { Integer(Faker::Number.within(range: 1..250)) }
    repository_name { Faker::Hipster.word }
    number { Integer(Faker::Number.number(digits: 1)) }
    state { 'open' }
    github_user_ids { [] }
    url { Faker::Internet.url }
    issue_id { Integer(Faker::Number.number(digits: 10)) }
    closed_at { nil }

    trait :closed do
      closed_at { Date.today }
    end

    factory :closed_sprint_ticket, traits: [:closed]
  end
end