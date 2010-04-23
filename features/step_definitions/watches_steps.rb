Given /^the following watches:$/ do |table|
  table.map_column!('user') { |name| User.find_or_create_by_login(name) }
  table.map_column!('video_content') { |name| VideoContent.find_by_name(name) }
  Watch.create!(table.hashes)
end