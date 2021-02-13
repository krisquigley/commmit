FactoryBot.define do
  factory :account do
    name { Faker::Hipster.word }
    subdomain { 'default' }
  end
end