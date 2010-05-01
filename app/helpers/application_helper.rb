require 'rubygems'
require 'uuidtools'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def truncate_and_tooltip(args)
    text, max_length = args[:text], args[:max_length]
    truncated = truncate(text, max_length)
    return text if text == truncated

    uuid = UUIDTools::UUID.random_create.to_s.gsub('-', '')
    result = "<span id=\"text_#{uuid}\">#{h(truncated)}</span>\n"
    result += yui_tooltip("text_#{uuid}", text)
    return result
  
  end
  
  def yui_tooltip(element_id, text)
    result = "<script>"
    result += "var var_tt_#{element_id} = new YAHOO.widget.Tooltip(\"tt_#{element_id}\", { context:\"#{element_id}\", text:\"#{h(text)}\" });"
    result += "</script>\n"
    return result
  end  
  
  def truncate(text, max_length)
    return '' if text.nil? || max_length.nil?
    return text if text.length <= max_length
    return "..." if max_length <= 3
    return text[0, (max_length - 3)] + '...'
  end  
  
  def truncate_from_start(text, max_length)
    return '' if text.nil? || max_length.nil?
    return text if text.length <= max_length
    return "..." if max_length <= 3
    return "..." + text[text.length - (max_length - 3), text.length]
  end
  
  def truncate_from_start_and_tooltip(args)
    text, max_length = args[:text], args[:max_length]
    truncated = truncate_from_start(text, max_length)
    return text if text == truncated

    uuid = UUIDTools::UUID.random_create.to_s.gsub('-', '')
    result = "<span id=\"text_#{uuid}\">#{h(truncated)}</span>\n"
    result += yui_tooltip("text_#{uuid}", text)
    return result
  end  
  
  # Allowed args:
  # text - to be displayed in button
  # link - to link too
  #        or
  # onclick - javascript function to call on click
  def yui_button_link(args)
    link, text = args[:link], args[:text]
    result = "<span class=\"yui-button yui-link-button\"><span class=\"first-child\">"
    unless link.nil?
      result += "<a href=\"#{link}\">#{text}</a>"
    else
      result += "<a onclick=\"#{args[:onclick]}\">#{text}</a>"
    end  
    result += "</span></span>"
    return result
  end

  def yui_submit_button(text)
    result = "<span class=\"yui-button yui-push-button\" style=\"vertical-align: bottom;\"><span class=\"first-child\">"
    result += '<button type="submit">' + text + '</button>'
    result += "</span></span>"
    return result
  end
  
  def poster_width_and_height(video_poster, max_width, max_height)
    width = video_poster.width    
    height = video_poster.height
    
    if width > max_width
      ratio = Float(max_width) / Float(width)
      width = max_width
      height = Integer(height * ratio)
    end
    
    if height > max_height
      ratio = Float(max_height) / Float(height)
      height = max_height
      width = Integer(width * ratio)
    end  
    
    return %(width="#{width}" height="#{height}")
  end  
  
end
