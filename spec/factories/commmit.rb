# frozen_string_literal: true

FactoryBot.define do
  factory :commmit do
    name { Faker::Hipster.word }
    start_date { Date.today }
    length_in_days { 1 }
  end
end
