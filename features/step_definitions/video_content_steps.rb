Given /^the following Movies:$/ do |video_contents|
  Movie.create!(video_contents.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) video_content$/ do |pos|
  visit video_contents_url
  within("tr[#{pos.to_i}]") do
    click_link "Destroy"
  end
end
