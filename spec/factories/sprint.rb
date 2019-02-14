FactoryBot.define do
  factory :sprint do
    name { Faker::Hipster.word }
    start_date { Time.now.ago(1.week) }
    end_date { Time.now.advance(weeks: 1) }

    factory :sprint_with_tickets do
      transient do
        tickets_count { 20 }
      end

      after(:create) do |sprint, evaluator|
        create_list(:sprint_ticket, evaluator.tickets_count, sprint: sprint)
      end
    end
  end
end