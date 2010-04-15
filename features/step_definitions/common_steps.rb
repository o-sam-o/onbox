Then /^show me the page$/ do
  save_and_open_page
end

Given /^a user is logged in as "(.*)"$/ do |login|
  @current_user = User.create!(
    :login => login,
    :password => 'generic',
    :password_confirmation => 'generic'
  )

  visit new_user_session_path
  fill_in("Login", :with => login) 
  fill_in("Password", :with => 'generic') 
  click_button("Login")
  
  
  Then "I should see \"Welcome #{login}\""
end