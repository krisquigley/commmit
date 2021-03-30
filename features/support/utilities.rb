# frozen_string_literal: true

def t(string, options = {})
  I18n.t(string, **options)
end

def submit_form
  find('input[name="commit"]').click
end
