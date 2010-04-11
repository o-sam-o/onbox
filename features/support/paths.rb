module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
      
    when /the new video_content page/
      new_video_content_path

    when /the "([^\"]*)" video_content page/
      video_content_path(VideoContent.find_by_name($1))

    when /the video_contents index page/
      video_contents_path

    when /the bulk video_content change page/
      bulk_change_search_path

    when /the new video_file_reference page/
      new_video_file_reference_path

    when /the video_file_references page/
      video_file_references_path

    when /the new media_folder page/
      new_media_folder_path

    when /the media_folders page/
      media_folders_path
    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
