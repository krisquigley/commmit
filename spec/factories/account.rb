# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { Faker::Hipster.word }
    subdomain { 'default' }
    account_type { 'personal' }
    owner_user_id { 123 }
  end
end
