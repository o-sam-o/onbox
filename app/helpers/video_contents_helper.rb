module VideoContentsHelper
  
  def view_content_details(label_name, value)
    if value.present?
      result = "<div class=\"viewDetailsWrapper\">\n"
			result << "	<div class=\"viewDetailsLabel\">#{h(label_name)}:</div>\n"
			result << "	<div class=\"viewDetailsValue\">" + truncate_and_tooltip({:text => value.to_s, :max_length => 25}) + "</div>\n"
			result << "</div>\n"
    end
  end
  
  
end
