# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    title { Faker::Hipster.sentence }
    estimated_effort { Integer(Faker::Number.within(range: 1..250)) }
    repository_name { Faker::Hipster.word }
    number { Integer(Faker::Number.number(digits: 1)) }
    state { %w[open closed].sample }
    github_user_ids { [] }
    url { Faker::Internet.url }
    issue_id { Integer(Faker::Number.number(digits: 10)) }
    source { File.open("#{Rails.root}/spec/fixtures/files/opened_issue_payload.json").read }

    trait :closed do
      closed_at { Time.now + 10.minutes }
    end

    trait :assigned_at do
      assigned_at { Time.now + 5.minutes }
    end

    factory :closed_and_assigned_tickets, traits: %i[closed assigned_at]
  end
end
