Given /^the following episodes:$/ do |table|
  table.map_column!('tv_show') { |show_name| TvShow.find_by_name(show_name) }
  TvEpisode.create!(table.hashes)
end