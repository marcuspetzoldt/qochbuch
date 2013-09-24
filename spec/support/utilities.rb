def sign_in(user)
  fill_in('Email', with: user.email)
  fill_in('Password', with: user.password)
  click_button('commitSignon')
  sleep(2)
end

# USAGE: fill_in_ckeditor 'email_body', :with => 'This is my message!'
def fill_in_ckeditor(locator, opts)
# browser = page.driver.browser
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
    CKEDITOR.instances['#{locator}'].setData(#{content});
    $('textarea##{locator}').text(#{content});
  SCRIPT
end

