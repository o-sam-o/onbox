class HomeController < ApplicationController
  def index
    #TODO add support for pagination
    @video_contents = VideoContent.all
  end

end
