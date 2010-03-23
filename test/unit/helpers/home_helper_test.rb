require 'test_helper'
require 'mocha'

class HomeHelperTest < ActionView::TestCase
  
  should "render template to string" do
    mock_controller = mock()
    expects(:controller).returns(mock_controller)
    mock_controller.expects(:render_to_string)
    render_to_string('test')
  end
  
end
