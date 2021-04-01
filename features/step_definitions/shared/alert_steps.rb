# frozen_string_literal: true

Then('I should be notified that my {string} was {string}') do |resource, notice|
  controller = resource.downcase.pluralize
  expect(page).to have_content t("#{controller}.notice.#{notice}")
end
