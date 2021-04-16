# frozen_string_literal: true

FactoryBot.define do
  factory :planned_story do
    trait :completed do
      completed_at { Time.now }
    end

    factory :completed_planned_story, traits: [:completed]
  end
end
