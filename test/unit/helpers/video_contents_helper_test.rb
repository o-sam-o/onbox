require File.dirname(__FILE__) + '/../../test_helper'

class VideoContentsHelperTest < ActionView::TestCase
    
  should "render label and value in correct divs" do
    expects(:truncate_and_tooltip).returns('test value')
    html = view_content_details('test label', 'test value')
    assert_match /.*(test label).*/, html
    assert_match /.*(test value).*/, html    
  end

  should "not render anything if there is no value" do
    assert view_content_details('test label', nil).blank?
    assert view_content_details('test label', '').blank?
  end

  
end
