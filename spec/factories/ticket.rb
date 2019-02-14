FactoryBot.define do
  factory :ticket do
    title { Faker::Hipster.sentence }
    estimated_effort { Integer(Faker::Number.number(1)) }
    repository_name { Faker::Hipster.word }
    number { Integer(Faker::Number.number(1)) }
    state { ['open', 'closed'].sample }
    github_user_ids { [] }
    url { Faker::Internet.url }
    issue_id { Integer(Faker::Number.number(10)) }
    source { "{}" }
  end
end