def click_archive_button(resource)
  find("button[name='archive_#{resource}']").click
end