require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should_have_many :video_contents


  should "mark a video_content as watched or not watched" do
    video = VideoContent.find_by_name('name 1')
    user = User.find_by_login('user1')
    
    user.has_watched(video)
    assert_equal 1, Watch.count(:conditions => ['user_id = ? and video_content_id =?', user, video])
    assert user.watched?(video)
    
    # Ensure calling twice doesnt cause a problem
    user.has_watched(video)
    assert_equal 1, Watch.count(:conditions => ['user_id = ? and video_content_id =?', user, video])
    assert user.watched?(video)
    
    user.has_not_watched(video)
    assert_equal 0, Watch.count(:conditions => ['user_id = ? and video_content_id =?', user, video])
    assert !user.watched?(video)
    # Ensure calling twice doenst cause a problem
    user.has_not_watched(video)
    assert_equal 0, Watch.count(:conditions => ['user_id = ? and video_content_id =?', user, video])   
    assert !user.watched?(video)
    
    # Ensure we test with a reset state
    user.has_watched(video)
    assert_equal 1, Watch.count(:conditions => ['user_id = ? and video_content_id =?', user, video])    
    assert user.watched?(video)
    user.has_not_watched(video) 
  end
  
end
