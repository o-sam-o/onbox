require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  should "truncate from the start of a string" do
    assert_equal "no truncate", truncate_from_start("no truncate", 50)
    assert_equal "no truncate", truncate_from_start("no truncate", 11)
    assert_equal "...runcate", truncate_from_start("do truncate", 10)
    assert_equal "...te", truncate_from_start("do truncate", 5)
    
    assert_equal "...", truncate_from_start("do truncate", 3)
    assert_equal "...", truncate_from_start("do truncate", 1)
    
    assert_equal "", truncate_from_start(nil, 1)
  end
  
  should "truncate from the end of a string" do
    assert_equal "no truncate", truncate("no truncate", 50)
    assert_equal "no truncate", truncate("no truncate", 11)
    assert_equal "do trun...", truncate("do truncate", 10)
    assert_equal "do...", truncate("do truncate", 5)
    
    assert_equal "...", truncate("do truncate", 3)
    assert_equal "...", truncate("do truncate", 1)
    
    assert_equal "", truncate_from_start(nil, 1)    
  end
  
  should "make a link that looks like a yui button" do
    assert_equal "<span class=\"yui-button yui-link-button\"><span class=\"first-child\">" + 
      "<a href=\"http://test.com\">Link Text</a></span></span>", 
      yui_button_link(:link => "http://test.com", :text => "Link Text")
  end
  
  should "make a javascript link that looks like a yui button" do
    assert_equal "<span class=\"yui-button yui-link-button\"><span class=\"first-child\">" + 
      "<a onclick=\"myFunction()\">Link Text</a></span></span>", 
      yui_button_link(:onclick => "myFunction()", :text => "Link Text")
  end
  
  should "truncate a string but add a tooltip so you can see it completely" do
    assert_equal "no truncate", truncate_and_tooltip(:text => 'no truncate', :max_length => 50) 
    
    html = truncate_and_tooltip(:text => 'do truncate', :max_length => 5)
    # I dont really want to inspect the html, just ensure both the truncated and complete version in there
    assert_match /.*(do\.\.\.).*/, html
    assert_match /.*(do truncate).*/, html
  end
  
  should "correctly size images" do
    assert_equal 'width="100" height="140"', poster_width_and_height(VideoPoster.new(:width => 100, :height => 140), 100, 140)
    
    assert_equal 'width="90" height="130"', poster_width_and_height(VideoPoster.new(:width => 90, :height => 130), 100, 140)
    
    # Resizes
    assert_equal 'width="100" height="70"', poster_width_and_height(VideoPoster.new(:width => 200, :height => 140), 100, 140)
    assert_equal 'width="50" height="140"', poster_width_and_height(VideoPoster.new(:width => 100, :height => 280), 100, 140)
    
    # More than one resize
    assert_equal 'width="93" height="140"', poster_width_and_height(VideoPoster.new(:width => 200, :height => 300), 100, 140)
    assert_equal 'width="100" height="70"', poster_width_and_height(VideoPoster.new(:width => 400, :height => 280), 100, 140)
    
    assert_equal '', poster_width_and_height(VideoPoster.new(:width => nil, :height => nil), 100, 140)
  end  
  
end