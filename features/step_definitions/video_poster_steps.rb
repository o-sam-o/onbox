Given /^the following video_posters:$/ do |video_posters|
  video_posters.map_column!('video_content', false) { |content_name| VideoContent.find_by_name(content_name) }
  VideoPoster.create!(video_posters.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) video_poster for "([^\"]*)"$/ do |pos, content_name|
  visit video_content_video_posters_url(VideoContent.find_by_name(content_name))
  within("tr[#{pos.to_i}]") do
    click_link "Destroy"
  end
end
