FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    github_user_id { Integer(Faker::Number.number(10)) }
  end
end