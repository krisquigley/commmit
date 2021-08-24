# frozen_string_literal: true

FactoryBot.define do
  factory :story do
    goal { Faker::GreekPhilosophers.quote }
    reason { Faker::Lorem.sentence }
    notes { Faker::Lorem.sentences.join('. ') }
    repeatable { false }

    trait :repeatable do
      repeatable { true }
    end

    trait :discarded do
      discarded_at { Time.now }
    end

    trait :completed do
      completed_at { Time.now }
    end

    trait :automatic do
      automatically_add { true }
    end

    trait :with_values do
      values { create_list(:value, 1) }
    end

    factory :discarded_story, traits: [:discarded]
    factory :repeatable_story, traits: [:repeatable]
    factory :completed_story, traits: [:completed]
    factory :story_with_values, traits: [:with_values]
    factory :automatic_repeatable_story, traits: %i[automatic repeatable]
  end
end
