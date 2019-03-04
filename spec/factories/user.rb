FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    github_user_id { Integer(Faker::Number.number(10)) }
    source { "{}" }

    factory :user_with_team do
      after(:create) do |user, evaluator|
        create(:team, users: [user])
      end
    end
  end
end