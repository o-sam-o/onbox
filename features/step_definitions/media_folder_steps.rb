Given /^the following media_folders:$/ do |media_folders|
  MediaFolder.create!(media_folders.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) media_folder$/ do |pos|
  visit media_folders_url
  within("tr[#{pos.to_i}]") do
    click_link "Destroy"
  end
end

When /^I edit the (\d+)(?:st|nd|rd|th) media_folder$/ do |pos|
  within("tr[#{pos.to_i}]") do
    click_link "Edit"
  end
end
