Given /^the following users:$/ do |users|
  User.create!(users.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) user$/ do |pos|
  visit users_url
  within("tbody/tr[#{pos.to_i + 1}]") do
    click_link "Destroy"
  end
end

Given /^I logout$/ do
  click_link "Logout"
end
