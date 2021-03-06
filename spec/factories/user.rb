# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { "#{Faker::Internet.username(separators: %w[-])}#{rand(9_999_999)}" }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 10, max_length: 128) }
    password_confirmation { password }
    github_user_id { Integer(Faker::Number.number(digits: 10)) }
    source do
      JSON.parse(File.read("#{Rails.root}/spec/fixtures/files/new_user_payload.json"))['member']
          .to_json
    end
    confirmed_at { Time.now }
  end
end
