Given /^the following Movies:$/ do |video_contents|
  video_contents.map_column!('genres', false) { |name| [Genre.find_or_create_by_name(name)] }
  Movie.create!(video_contents.hashes)
end

Given /^the following TvShows:$/ do |video_contents|
  video_contents.map_column!('genres', false) { |name| [Genre.find_or_create_by_name(name)] }
  TvShow.create!(video_contents.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) video_content$/ do |pos|
  visit video_contents_url
  within("tr[#{pos.to_i}]") do
    click_link "Destroy"
  end
end
