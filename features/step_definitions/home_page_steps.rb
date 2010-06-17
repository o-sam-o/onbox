Given /^I load the home page items with an offset of (\d+) and a page size of (\d+)$/ do |offset, page_size|
  visit url_for :controller => 'home', :action => 'video_content_items', :offset => offset, :page_size => page_size
end

Given /^I order by "([^\"]*)"$/ do |order_by|
  Then %{I follow "#{order_by}"} 
end

Given /^I should see "([^\"]*)" as the (\d+)(?:st|nd|rd|th) video$/ do |video_name, order|
  within "li:nth-child(#{order})" do
    assert page.has_content?(video_name)
  end
end