FactoryBot.define do
  factory :sprint_ticket do
    title { Faker::Hipster.sentence }
    estimated_effort { Float(Faker::Number.number(1)) }
    repository_name { Faker::Hipster.word }
    number { Integer(Faker::Number.number(1)) }
    state { 'open' }
    github_user_ids { [] }
    url { Faker::Internet.url }
    issue_id { Integer(Faker::Number.number(10)) }
    closed_at { nil }
  end
end