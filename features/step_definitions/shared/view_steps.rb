# frozen_string_literal: true

Then('see {string} in my list of {string}') do |text, resource|
  visit path_for_resource(resource)
  expect(page).to have_content text
end

When('I visit the {string} page') do |resource|
  visit path_for_resource(resource)
end

When('I view the {string}') do |resource|
  record = instance_variable_get("@#{resource.downcase}")
  visit path_for_resource(resource, record)
end
