Given /^I load the home page items with an offset of (\d+) and a page size of (\d+)$/ do |offset, page_size|
  visit url_for :controller => 'home', :action => 'video_content_items', :offset => offset, :page_size => page_size
end