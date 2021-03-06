# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Hipster.word }

    factory :team_with_users do
      after(:create) do |team|
        create_list :user, 2, team: team
      end
    end
  end
end
