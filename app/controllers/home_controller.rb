class HomeController < ApplicationController
  CAROUSEL_WIDTH = 4
  CAROUSEL_HEIGHT = 1
  
  public :render_to_string
  
  def index
    @video_content_count = VideoContent.count
    @video_contents = VideoContent.all(:limit=>(CAROUSEL_WIDTH * CAROUSEL_HEIGHT))
  end
  
  #TODO add param validation to ensure page_size and offset
  def video_content_items
    @video_contents = VideoContent.all(:limit=> params['page_size'].to_i, :offset => params['offset'].to_i)
  end

end
