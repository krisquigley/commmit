# frozen_string_literal: true

FactoryBot.define do
  factory :reflection do
    trait :completed do
      notes { Faker::Lorem.sentence }
      happiness { [1, 2, 3, 4, 5].sample }
    end

    factory :completed_reflection, traits: [:completed]
  end
end
