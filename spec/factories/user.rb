
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    github_user_id { Integer(Faker::Number.number(10)) }
    source { JSON.parse(File.read("#{Rails.root.to_s}/spec/fixtures/files/new_user_payload.json"))["member"].to_json }
  end
end