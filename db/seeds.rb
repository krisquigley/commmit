# frozen_string_literal: true

# Create some users
puts 'Seeding database...'
default_user = User.create(
  name: Faker::Name.name,
  username: 'default',
  email: 'default@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now,
  github_user_id: Integer(Faker::Number.number(digits: 10)),
  source: JSON.parse(File
    .read("#{Rails.root}/spec/fixtures/files/new_user_payload.json"))['member'].to_json
)
printf('.')

default_account = Account.find_or_create_by(name: default_user.username,
                                            subdomain: default_user.username,
                                            account_type: 'personal',
                                            owner_user_id: default_user.id)
printf('.')

ActsAsTenant.current_tenant = default_account

puts 'Done'
