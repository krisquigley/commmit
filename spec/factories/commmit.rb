# frozen_string_literal: true

FactoryBot.define do
  factory :commmit do
    name { Faker::Hipster.word }
  end
end
