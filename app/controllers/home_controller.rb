class HomeController < ApplicationController
  CAROUSEL_WIDTH = 5
  CAROUSEL_HEIGHT = 2
  
  verify :params => ['offset', 'page_size'], :only => :video_content_items
  
  public :render_to_string
  
  def index
    @video_content_count = VideoContent.count
    @video_contents = VideoContent.all(:limit=>(CAROUSEL_WIDTH * CAROUSEL_HEIGHT))
  end
  
  def video_content_items
    @video_contents = VideoContent.all(:limit=> params['page_size'].to_i, :offset => params['offset'].to_i)
  end

end
