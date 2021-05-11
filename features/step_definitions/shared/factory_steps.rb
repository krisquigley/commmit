# frozen_string_literal: true

Given('I already have some {string}') do |resource|
  with_tenant do
    instance_variable_set("@#{resource.downcase}",
                          create_list(resource.downcase.singularize.to_sym, 5))
  end
end

Given('I already have some Commmits') do
  with_tenant do
    @commmits = [create(:commmit, end_date: Time.current.to_date.yesterday),
                 create(:commmit)]
  end
end

Given('I already have a {string}') do |resource|
  with_tenant do
    instance_variable_set("@#{resource.downcase}", create(resource.downcase.singularize.to_sym))
  end
end
