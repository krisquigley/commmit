# frozen_string_literal: true

FactoryBot.define do
  factory :value do
    name { Faker::Games::Pokemon.name }
  end
end
