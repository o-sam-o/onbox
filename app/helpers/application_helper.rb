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
    result += "<script>"
    result += "var var_#{uuid} = new YAHOO.widget.Tooltip(\"tt_#{uuid}\", { context:\"text_#{uuid}\", text:\"#{h(text)}\" });"
    result += "</script>\n"
    return result
  
  end
  
  def truncate(text, max_length)
    return text if text.length <= max_length
    return "..." if max_length <= 3
    return text[0, (max_length - 3)] + '...'
  end  
  
  def truncate_from_start(text, max_length)
    return text if text.length <= max_length
    return "..." if max_length <= 3
    return "..." + text[text.length - (max_length - 3), text.length]
  end

  def yui_button_link(args)
    link, text = args[:link], args[:text]
    result = "<span id=\"linkbutton2\" class=\"yui-button yui-link-button\"><span class=\"first-child\">"
    result += "<a href=\"#{link}\">#{text}</a>"
    result += "</span></span>"
    return result
  end
  
end
