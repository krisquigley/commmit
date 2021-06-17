# frozen_string_literal: true

module FormHelper
  def submit_form
    find('input[name="commit"]').click
  end
end
