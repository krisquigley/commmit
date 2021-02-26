FactoryBot.define do
  factory :user do
    
    name { Faker::Name.name }
    username { "#{Faker::Internet.username(separators: %w(-))}#{rand(9999999)}" }
    email { Faker::Internet::email }
    password { Faker::Internet.password(min_length: 10, max_length: 128) }
    password_confirmation { self.password }
    github_user_id { Integer(Faker::Number.number(digits: 10)) }
    source { JSON.parse(File.read("#{Rails.root.to_s}/spec/fixtures/files/new_user_payload.json"))["member"].to_json }
    confirmed_at { Time.now }
  end
end