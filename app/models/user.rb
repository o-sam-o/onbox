class User < ActiveRecord::Base
  has_many :video_contents, :through => :watches
  acts_as_authentic
  
  def has_watched(video_content)
    if !watched?(video_content)
      Watch.create!(:user_id => self.id, :video_content_id => video_content.id)
    end
  end
  
  def has_not_watched(video_content)
    watches = Watch.all(['user_id = ? and video_content_id = ?', self, video_content])
    watches.each {|w| w.destroy}
  end    
  
  def watched?(video_content)
    Watch.exists?(['user_id = ? and video_content_id = ?', self, video_content])
  end
end
