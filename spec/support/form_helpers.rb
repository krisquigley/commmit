# frozen_string_literal: true

module FormHelpers
  def submit_form
    find('input[name="commit"]').click
  end
end

RSpec.configure do |config|
  config.include FormHelpers, type: :feature
end
