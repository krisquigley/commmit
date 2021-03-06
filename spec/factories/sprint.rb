# frozen_string_literal: true

FactoryBot.define do
  factory :sprint do
    name { Faker::Hipster.word }
    start_date { Date.today.ago(4.days) }
    end_date { Date.today }

    trait :with_tickets do
      transient do
        tickets_count { 5 }
      end

      after(:create) do |sprint, evaluator|
        create_list(:sprint_ticket, evaluator.tickets_count, sprint: sprint)
      end
    end

    trait :with_closed_tickets do
      transient do
        tickets_count { 5 }
      end

      after(:create) do |sprint, evaluator|
        create_list(:closed_sprint_ticket, evaluator.tickets_count, sprint: sprint)
      end
    end

    factory :sprint_with_tickets, traits: [:with_tickets]
    factory :sprint_with_closed_tickets, traits: [:with_closed_tickets]
  end
end
