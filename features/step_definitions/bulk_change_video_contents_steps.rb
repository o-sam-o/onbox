

When /^I select the bulk change checkbox for "([^\"]*)"$/ do |video_name|
  all('td').each do |td|
    if td.text ==  video_name
      tr_scope = td.path[1, td.path.rindex('td') + 1]
      with_scope(tr_scope) do
        check('video_content_ids[]')
      end
    end  
  end
end