FactoryBot.define do
  factory :team do
    name { Faker::Hipster.word }

    factory :team_with_sprint do
      after(:create) do |team, evaluator|
        create(:sprint_with_tickets, team: team)
      end
    end
  end
end