FactoryBot.define do
  factory :department do
    name { Faker::Hipster.word }

    factory :department_with_teams do
      after(:create) do |department|
        create_list :team_with_users, 2, department: department
      end
    end
  end
end