Given /^the following video_file_references:$/ do |video_file_references|
  video_file_references.map_column!('media_folder') { |folder_name| MediaFolder.find_or_create_by_location(folder_name) }
  VideoFileReference.create!(video_file_references.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) video_file_reference$/ do |pos|
  visit video_file_references_url
  within("tr[#{pos.to_i}]") do
    click_link "Destroy"
  end
end

When /^I edit the (\d+)(?:st|nd|rd|th) video_file_reference$/ do |pos|
  within("tr[#{pos.to_i}]") do
    click_link "Edit"
  end
end
