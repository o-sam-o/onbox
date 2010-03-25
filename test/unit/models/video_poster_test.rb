require 'test_helper'

class VideoPosterTest < ActiveSupport::TestCase
  should_validate_presence_of :size, :location
  should_validate_uniqueness_of :location
  should_belong_to :video_content
  
  should 'return size display name' do
    assert_equal 'Small', VideoPosterSize.display_name(:small)
  end 
  
  should 'return size select values' do
    assert_not_nil VideoPosterSize.select_values
  end  
  
end
